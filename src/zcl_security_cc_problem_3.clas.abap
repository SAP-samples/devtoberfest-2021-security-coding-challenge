CLASS zcl_security_cc_problem_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    "Uses Data Model - https://github.com/SAP-samples/abap-platform-refscen-flight
  PROTECTED SECTION.
  PRIVATE SECTION.
    "Simulate Input Parameters via a constant to keep example UI/Service/Interface agnostic
    CONSTANTS: dbTable TYPE string VALUE '/DMO/FLIGHT'.
ENDCLASS.



CLASS zcl_security_cc_problem_3 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA dref TYPE REF TO data.
    FIELD-SYMBOLS <results> TYPE STANDARD TABLE.
    CREATE DATA dref TYPE STANDARD TABLE OF (dbTable)
                     WITH EMPTY KEY.
    ASSIGN dref->* TO <results>.

    TRY.
        " only allow tables within /DMO/FLIGHT including all subpackages
        cl_abap_dyn_prg=>check_table_name_str(
            val = dbTable
            packages = '/DMO/FLIGHT'
            incl_sub_packages = abap_true
        ).
        SELECT * FROM (dbTable) INTO TABLE @<results> UP TO 100 ROWS.
        out->write( |Data for table: { dbTable }| ).
        out->write( <results> ).
      CATCH cx_abap_not_a_table cx_abap_not_in_package INTO DATA(lx_exception).
        "handle exception
        out->write( |error: { lx_exception->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
