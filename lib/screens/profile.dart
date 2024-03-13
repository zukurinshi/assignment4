          // //Bday field
          //         TextFormField(
          //            validator: (value){
          //             if(value == null || value.isEmpty) {
          //               return 'This field is required';
          //             }
          //           } ,
          //           controller: birthDate,
          //           decoration: InputDecoration(
          //             icon: Icon(Icons.calendar_today),
          //               labelText: 'Birth Date', border: OutlineInputBorder()),
          //               readOnly: true,
          //                onTap: () async {
          //       DateTime? pickedDate = await showDatePicker(
          //           context: context,
          //           initialDate: DateTime.now(),
          //           firstDate: DateTime(1950),
          //           lastDate: DateTime(2024));
 
          //       if (pickedDate != null) {
          //         print(
          //             pickedDate);
          //         String formattedDate =
          //             DateFormat.yMMMMEEEEd().format(pickedDate);
          //         print(
          //             formattedDate);
          //         setState(() {
          //           birthDate.text =
          //               formattedDate;
          //         });
          //       } else {}
          //     },
          //         ),