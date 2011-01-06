Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1AFSU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:20:29 -0500
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:60147 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab1AFSU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:20:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=qotGec+wHU6YhClBSu/Ah0DFZ+xbgAAKcvIwHZu+ElVxLh2IKubUwyb8w9iIXhhI;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D2607E8.1040305@earthlink.net>
Date: Thu, 06 Jan 2011 13:20:24 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 2.6.37 erroneously limiting to UDMA/33
References: <4D24B98D.6080307@earthlink.net> <20110106134704.20b91684@lxorguk.ukuu.org.uk>
In-Reply-To: <20110106134704.20b91684@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed;
 boundary="------------070608070704080505060302"
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec7917a26d1beb45d2d389fd4c094661de3b350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070608070704080505060302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/06/2011 08:47 AM, Alan Cox wrote:
> On Wed, 05 Jan 2011 13:33:49 -0500
> Stephen Clark<sclark46@earthlink.net>  wrote:
>
>    
>> Hello,
>>
>> Why is the kernel limiting me to udma/33 when the device says it can do
>> ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
>>
>> There is no cable the compact flash is a socket on the motherboard!
>>      
> The kernel follows the ATA detection rules. If you have an adapter wedged
> into the PATA socket one motherboard then it could well be either the
> adapter isn't UDMA/66 capable or is not properly supporting cable detect.
>
> You can force it with boot options.
>
> If the CF socket is directly wired to and part of the motherboard (ie
> it's part of the board configuration), then can you send me a dmidecode,
> lspci and lspci --vvxxx as we can patch up configurations that are fixed,
> but not user added adapters.
>
> Alan
>
>    
The cf flash socket is soldered directly to the mother board.
I am attaching the dmidecode for the mother board.

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)




--------------070608070704080505060302
Content-Type: text/plain;
 name="dmidecode.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmidecode.txt"

# dmidecode 2.10
SMBIOS 2.3 present.
33 structures occupying 898 bytes.
Table at 0x000F0800.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
	Vendor: Phoenix Technologies, LTD
	Version: 6.00 PG
	Release Date: 05/27/2008
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 1024 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/360 kB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		AGP is supported
		BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
	Manufacturer:  
	Product Name:  
	Version:  
	Serial Number:  
	UUID: Not Present
	Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer:  
	Product Name: CN700-8251
	Version:  
	Serial Number:  

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer:  
	Type: Desktop
	Lock: Not Present
	Version:  
	Serial Number:  
	Asset Tag:  
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown
	OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: Socket 370
	Type: Central Processor
	Family: Other
	Manufacturer: VIA
	ID: D0 06 00 00 FF BB C9 A7
	Version: VIA C7
	Voltage: 0.9 V
	External Clock: 100 MHz
	Max Speed: 1000 MHz
	Current Speed: 1000 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0008
	L2 Cache Handle: 0x0009
	L3 Cache Handle: Not Provided
	Serial Number:  
	Asset Tag:  
	Part Number:  

Handle 0x0005, DMI type 5, 20 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: Four-way Interleave
	Maximum Memory Module Size: 32 MB
	Maximum Total Memory Size: 64 MB
	Supported Speeds:
		70 ns
		60 ns
	Supported Memory Types:
		Standard
		EDO
	Memory Module Voltage: 5.0 V
	Associated Memory Slots: 2
		0x0006
		0x0007
	Enabled Error Correcting Capabilities: None

Handle 0x0006, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A0
	Bank Connections: 0
	Current Speed: 37 ns
	Type: Other
	Installed Size: 512 MB (Single-bank Connection)
	Enabled Size: 512 MB (Single-bank Connection)
	Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A1
	Bank Connections: None
	Current Speed: 37 ns
	Type: Other
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x0008, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 kB
	Maximum Size: 128 kB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x0009, DMI type 7, 19 bytes
Cache Information
	Socket Designation: External Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: External
	Installed Size: 128 kB
	Maximum Size: 128 kB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PRIMARY IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SECONDARY IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FDD
	Internal Connector Type: On Board Floppy
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: 8251 FIFO Compatible

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator:  
	External Connector Type: DB-9 male
	Port Type: Serial Port 16450 Compatible

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM2
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator:  
	External Connector Type: DB-9 male
	Port Type: Serial Port 16450 Compatible

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LPT1
	Internal Connector Type: DB-25 female
	External Reference Designator:  
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Keyboard
	Internal Connector Type: PS/2
	External Reference Designator:  
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Mouse
	Internal Connector Type: PS/2
	External Reference Designator:  
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB0
	External Connector Type: Other
	Port Type: USB

Handle 0x0013, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI0
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 1
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0014, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 2
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0015, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 3
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0016, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI3
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 4
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0017, DMI type 9, 13 bytes
System Slot Information
	Designation: AGP
	Type: 32-bit AGP
	Current Usage: Available
	Length: Long
	ID: 8
	Characteristics:
		5.0 V is provided

Handle 0x0018, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 3
		n|US|iso8859-1
		n|US|iso8859-1
		r|CA|iso8859-1
	Currently Installed Language: n|US|iso8859-1

Handle 0x0019, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 1 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x001A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0019
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: 512 MB
	Form Factor: DIMM
	Set: None
	Locator: A0
	Bank Locator: Bank0/1
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x001B, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0019
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: A1
	Bank Locator: Bank2/3
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x001C, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Array Handle: 0x0019
	Partition Width: 0

Handle 0x001D, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x001A
	Memory Array Mapped Address Handle: 0x001C
	Partition Row Position: 1

Handle 0x001E, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x001B
	Memory Array Mapped Address Handle: 0x001C
	Partition Row Position: 1

Handle 0x001F, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0020, DMI type 127, 4 bytes
End Of Table


--------------070608070704080505060302--
