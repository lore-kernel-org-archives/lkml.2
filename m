Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095Ab2ERBJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 21:09:01 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:37016 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761133Ab2ERBIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 21:08:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1337303328!5851430!22
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove all 'default N' in Kconfig
Date: Thu, 17 May 2012 18:08:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205171808.37565.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the 'default N' lines in the comedi Kconfig. They should all
be 'default n' but that is the default anyway.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index a1cf0b0..3bbe3fd 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1,6 +1,5 @@
 config COMEDI
 	tristate "Data acquisition support (comedi)"
-	default N
 	depends on m
 	depends on BROKEN || FRV || M32R || MN10300 || SUPERH || TILE || X86
 	---help---
@@ -37,7 +36,6 @@ config COMEDI_DEFAULT_BUF_MAXSIZE_KB
 menuconfig COMEDI_MISC_DRIVERS
 	tristate "Comedi misc drivers"
 	depends on COMEDI
-	default N
 	---help---
 	  Enable comedi misc drivers to be built
 
@@ -55,7 +53,6 @@ config COMEDI_KCOMEDILIB
 config COMEDI_BOND
 	tristate "Device bonding support"
 	depends on COMEDI_KCOMEDILIB
-	default N
 	---help---
 	  Enable support for a driver to 'bond' (merge) multiple subdevices
 	  from multiple devices together as one.
@@ -66,7 +63,6 @@ config COMEDI_BOND
 config COMEDI_TEST
 	tristate "Fake waveform generator support"
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for the fake waveform generator.
 	  This driver is mainly for testing purposes, but can also be used to
@@ -78,7 +74,6 @@ config COMEDI_TEST
 
 config COMEDI_PARPORT
 	tristate "Parallel port support"
-	default N
 	---help---
 	  Enable support for the standard parallel port.
 	  A cheap and easy way to get a few more digital I/O lines. Steal
@@ -90,7 +85,6 @@ config COMEDI_PARPORT
 
 config COMEDI_SERIAL2002
 	tristate "Driver for serial connected hardware"
-	default N
 	---help---
 	  Enable support for serial connected hardware
 
@@ -99,7 +93,6 @@ config COMEDI_SERIAL2002
 
 config COMEDI_SKEL
 	tristate "Comedi skeleton driver"
-	default N
 	---help---
 	  Build the Skeleton driver, an example for driver writers
 
@@ -111,7 +104,6 @@ endif # COMEDI_MISC_DRIVERS
 menuconfig COMEDI_ISA_DRIVERS
 	tristate "Comedi ISA and PC/104 drivers"
 	depends on COMEDI && ISA
-	default N
 	---help---
 	  Enable comedi ISA and PC/104 drivers to be built
 
@@ -123,7 +115,6 @@ if COMEDI_ISA_DRIVERS && ISA
 
 config COMEDI_ACL7225B
 	tristate "ADlink NuDAQ ACL-7225b and compatibles support"
-	default N
 	---help---
 	  Enable support for ADlink NuDAQ ACL-7225b and compatibles,
 	  ADlink ACL-7225b (acl7225b), ICP P16R16DIO (p16r16dio)
@@ -133,7 +124,6 @@ config COMEDI_ACL7225B
 
 config COMEDI_PCL711
 	tristate "Advantech PCL-711/711b and ADlink ACL-8112 ISA card support"
-	default N
 	---help---
 	  Enable support for Advantech PCL-711 and 711b, ADlink ACL-8112
 
@@ -143,7 +133,6 @@ config COMEDI_PCL711
 config COMEDI_PCL724
 	tristate "Advantech PCL-722/724/731 and ADlink ACL-7122/7124/PET-48DIO"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for Advantech PCL-724, PCL-722, PCL-731 and
 	  ADlink ACL-7122, ACL-7124, PET-48DIO ISA cards
@@ -153,7 +142,6 @@ config COMEDI_PCL724
 
 config COMEDI_PCL725
 	tristate "Advantech PCL-725 and compatible ISA card support"
-	default N
 	---help---
 	  Enable support for Advantech PCL-725 and compatible ISA cards.
 
@@ -162,7 +150,6 @@ config COMEDI_PCL725
 
 config COMEDI_PCL726
 	tristate "Advantech PCL-726 and compatible ISA card support"
-	default N
 	---help---
 	  Enable support for Advantech PCL-726 and compatible ISA cards.
 
@@ -171,7 +158,6 @@ config COMEDI_PCL726
 
 config COMEDI_PCL730
 	tristate "Advantech PCL-730 and ADlink ACL-7130 ISA card support"
-	default N
 	---help---
 	  Enable support for Advantech PCL-730, ICP ISO-730 and ADlink
 	  ACL-7130 ISA cards
@@ -182,7 +168,6 @@ config COMEDI_PCL730
 config COMEDI_PCL812
 	tristate "Advantech PCL-812/813 and ADlink ACL-8112/8113/8113/8216"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for Advantech PCL-812/PG, PCL-813/B, ADLink
 	  ACL-8112DG/HG/PG, ACL-8113, ACL-8216, ICP DAS A-821PGH/PGL/PGL-NDA,
@@ -194,7 +179,6 @@ config COMEDI_PCL812
 config COMEDI_PCL816
 	tristate "Advantech PCL-814 and PCL-816 ISA card support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for Advantech PCL-814 and PCL-816 ISA cards
 
@@ -204,7 +188,6 @@ config COMEDI_PCL816
 config COMEDI_PCL818
 	tristate "Advantech PCL-718 and PCL-818 ISA card support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for Advantech PCL-818 ISA cards
 	  PCL-818L, PCL-818H, PCL-818HD, PCL-818HG, PCL-818 and PCL-718
@@ -215,7 +198,6 @@ config COMEDI_PCL818
 config COMEDI_PCM3724
 	tristate "Advantech PCM-3724 PC/104 card support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for Advantech PCM-3724 PC/104 cards.
 
@@ -224,7 +206,6 @@ config COMEDI_PCM3724
 
 config COMEDI_PCM3730
 	tristate "Advantech PCM-3730 and clone PC/104 board support"
-	default N
 	---help---
 	  Enable support for Advantech PCM-3730 and clone PC/104 boards
 
@@ -235,7 +216,6 @@ config COMEDI_AMPLC_DIO200_ISA
 	tristate "Amplicon PC212E/PC214E/PC215E/PC218E/PC272E"
 	select COMEDI_AMPLC_DIO200
 	depends on COMEDI_ISA_DRIVERS
-	default N
 	---help---
 	  Enable support for Amplicon PC212E, PC214E, PC215E, PC218E and
 	  PC272E ISA DIO boards
@@ -246,7 +226,6 @@ config COMEDI_AMPLC_DIO200_ISA
 config COMEDI_AMPLC_PC236_ISA
 	tristate "Amplicon PC36AT DIO board support"
 	select COMEDI_AMPLC_PC236
-	default N
 	---help---
 	  Enable support for Amplicon PC36AT ISA DIO board.
 
@@ -256,7 +235,6 @@ config COMEDI_AMPLC_PC236_ISA
 config COMEDI_AMPLC_PC263_ISA
 	tristate "Amplicon PC263 relay board support"
 	select COMEDI_AMPLC_PC263
-	default N
 	---help---
 	  Enable support for Amplicon PC263 ISA relay board.
 
@@ -265,7 +243,6 @@ config COMEDI_AMPLC_PC263_ISA
 
 config COMEDI_RTI800
 	tristate "Analog Devices RTI-800/815 ISA card support"
-	default N
 	---help---
 	  Enable support for Analog Devices RTI-800/815 ISA cards
 
@@ -274,7 +251,6 @@ config COMEDI_RTI800
 
 config COMEDI_RTI802
 	tristate "Analog Devices RTI-802 ISA card support"
-	default N
 	---help---
 	  Enable support for Analog Devices RTI-802 ISA cards
 
@@ -285,7 +261,6 @@ config COMEDI_DAS16M1
 	tristate "MeasurementComputing CIO-DAS16/M1DAS-16 ISA card support"
 	select COMEDI_8255
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for Measurement Computing CIO-DAS16/M1 ISA cards.
 
@@ -295,7 +270,6 @@ config COMEDI_DAS16M1
 config COMEDI_DAS08_ISA
 	tristate "DAS-08 compatible ISA and PC/104 card support"
 	select COMEDI_DAS08
-	default N
 	---help---
 	  Enable support for Keithley Metrabyte/ComputerBoards DAS08
 	  and compatible ISA and PC/104 cards:
@@ -310,7 +284,6 @@ config COMEDI_DAS16
 	tristate "DAS-16 compatible ISA and PC/104 card support"
 	select COMEDI_8255
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for Keithley Metrabyte/ComputerBoards DAS16
 	  and compatible ISA and PC/104 cards:
@@ -327,7 +300,6 @@ config COMEDI_DAS16
 config COMEDI_DAS800
 	tristate "DAS800 and compatible ISA card support"
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for Keithley Metrabyte DAS800 and compatible ISA cards
 	  Keithley Metrabyte DAS-800, DAS-801, DAS-802
@@ -341,7 +313,6 @@ config COMEDI_DAS1800
 	tristate "DAS1800 and compatible ISA card support"
 	depends on VIRT_TO_BUS
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for DAS1800 and compatible ISA cards
 	  Keithley Metrabyte DAS-1701ST, DAS-1701ST-DA, DAS-1701/AO,
@@ -355,7 +326,6 @@ config COMEDI_DAS1800
 
 config COMEDI_DAS6402
 	tristate "DAS6402 and compatible ISA card support"
-	default N
 	---help---
 	  Enable support for DAS6402 and compatible ISA cards
 	  Computerboards, Keithley Metrabyte DAS6402 and compatibles
@@ -365,7 +335,6 @@ config COMEDI_DAS6402
 
 config COMEDI_DT2801
 	tristate "Data Translation DT2801 ISA card support"
-	default N
 	---help---
 	  Enable support for Data Translation DT2801 ISA cards
 
@@ -374,7 +343,6 @@ config COMEDI_DT2801
 
 config COMEDI_DT2811
 	tristate "Data Translation DT2811 ISA card support"
-	default N
 	---help---
 	  Enable support for Data Translation DT2811 ISA cards
 
@@ -383,7 +351,6 @@ config COMEDI_DT2811
 
 config COMEDI_DT2814
 	tristate "Data Translation DT2814 ISA card support"
-	default N
 	---help---
 	  Enable support for Data Translation DT2814 ISA cards
 
@@ -392,7 +359,6 @@ config COMEDI_DT2814
 
 config COMEDI_DT2815
 	tristate "Data Translation DT2815 ISA card support"
-	default N
 	---help---
 	  Enable support for Data Translation DT2815 ISA cards
 
@@ -401,7 +367,6 @@ config COMEDI_DT2815
 
 config COMEDI_DT2817
 	tristate "Data Translation DT2817 ISA card support"
-	default N
 	---help---
 	  Enable support for Data Translation DT2817 ISA cards
 
@@ -412,7 +377,6 @@ config COMEDI_DT282X
 	tristate "Data Translation DT2821 series and DT-EZ ISA card support"
 	select COMEDI_FC
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for Data Translation DT2821 series including DT-EZ
 	  DT2821, DT2821-F-16SE, DT2821-F-8DI, DT2821-G-16SE, DT2821-G-8DI,
@@ -424,7 +388,6 @@ config COMEDI_DT282X
 
 config COMEDI_DMM32AT
 	tristate "Diamond Systems MM-32-AT PC/104 board support"
-	default N
 	---help---
 	  Enable support for Diamond Systems MM-32-AT PC/104 boards
 
@@ -433,7 +396,6 @@ config COMEDI_DMM32AT
 
 config COMEDI_FL512
 	tristate "FL512 ISA card support"
-	default N
 	---help---
 	  Enable support for FL512 ISA card
 
@@ -443,7 +405,6 @@ config COMEDI_FL512
 config COMEDI_AIO_AIO12_8
 	tristate "I/O Products PC/104 AIO12-8 Analog I/O Board support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for I/O Products PC/104 AIO12-8 Analog I/O Board
 
@@ -452,7 +413,6 @@ config COMEDI_AIO_AIO12_8
 
 config COMEDI_AIO_IIRO_16
 	tristate "I/O Products PC/104 IIRO16 Board support"
-	default N
 	---help---
 	  Enable support for I/O Products PC/104 IIRO16 Relay And Isolated
 	  Input Board
@@ -462,7 +422,6 @@ config COMEDI_AIO_IIRO_16
 
 config COMEDI_C6XDIGIO
 	tristate "Mechatronic Systems Inc. C6x_DIGIO DSP daughter card support"
-	default N
 	---help---
 	  Enable support for Mechatronic Systems Inc. C6x_DIGIO DSP daughter
 	  card
@@ -472,7 +431,6 @@ config COMEDI_C6XDIGIO
 
 config COMEDI_MPC624
 	tristate "Micro/sys MPC-624 PC/104 board support"
-	default N
 	---help---
 	  Enable support for Micro/sys MPC-624 PC/104 board
 
@@ -481,7 +439,6 @@ config COMEDI_MPC624
 
 config COMEDI_ADQ12B
 	tristate "MicroAxial ADQ12-B data acquisition and control card support"
-	default N
 	---help---
 	  Enable MicroAxial ADQ12-B daq and control card support.
 
@@ -492,7 +449,6 @@ config COMEDI_NI_AT_A2150
 	tristate "NI AT-A2150 ISA card support"
 	depends on COMEDI_NI_COMMON
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for National Instruments AT-A2150 cards
 
@@ -502,7 +458,6 @@ config COMEDI_NI_AT_A2150
 config COMEDI_NI_AT_AO
 	tristate "NI AT-AO-6/10 EISA card support"
 	depends on COMEDI_NI_COMMON
-	default N
 	---help---
 	  Enable support for National Instruments AT-AO-6/10 cards
 
@@ -513,7 +468,6 @@ config COMEDI_NI_ATMIO
 	tristate "NI AT-MIO E series ISA-PNP card support"
 	depends on ISAPNP && COMEDI_NI_TIO && COMEDI_NI_COMMON
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for National Instruments AT-MIO E series cards
 	  National Instruments AT-MIO-16E-1 (ni_atmio),
@@ -527,7 +481,6 @@ config COMEDI_NI_ATMIO16D
 	tristate "NI AT-MIO16/AT-MIO16D series ISA-PNP card support"
 	depends on ISAPNP && COMEDI_NI_COMMON
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for National Instruments AT-MIO16/AT-MIO16D cards.
 
@@ -536,7 +489,6 @@ config COMEDI_NI_ATMIO16D
 
 config COMEDI_PCMAD
 	tristate "Winsystems PCM-A/D12 and PCM-A/D16 PC/104 board support"
-	default N
 	---help---
 	  Enable support for Winsystems PCM-A/D12 and PCM-A/D16 PC/104 boards.
 
@@ -545,7 +497,6 @@ config COMEDI_PCMAD
 
 config COMEDI_PCMDA12
 	tristate "Winsystems PCM-D/A-12 8-channel AO PC/104 board support"
-	default N
 	---help---
 	  Enable support for Winsystems PCM-D/A-12 8-channel AO PC/104 boards.
 	  Note that the board is not ISA-PNP capable and thus needs the I/O
@@ -556,7 +507,6 @@ config COMEDI_PCMDA12
 
 config COMEDI_PCMMIO
 	tristate "Winsystems PCM-MIO PC/104 board support"
-	default N
 	---help---
 	  Enable support for Winsystems PCM-MIO multifunction PC/104 boards.
 
@@ -565,7 +515,6 @@ config COMEDI_PCMMIO
 
 config COMEDI_PCMUIO
 	tristate "Winsystems PCM-UIO48A and PCM-UIO96A PC/104 board support"
-	default N
 	---help---
 	  Enable support for PCM-UIO48A and PCM-UIO96A PC/104 boards.
 
@@ -574,7 +523,6 @@ config COMEDI_PCMUIO
 
 config COMEDI_MULTIQ3
 	tristate "Quanser Consulting MultiQ-3 ISA card support"
-	default N
 	---help---
 	  Enable support for Quanser Consulting MultiQ-3 ISA cards
 
@@ -583,7 +531,6 @@ config COMEDI_MULTIQ3
 
 config COMEDI_POC
 	tristate "Generic driver for very simple devices"
-	default N
 	---help---
 	  Enable generic support for very simple / POC (Piece of Crap) boards,
 	  Keithley Metrabyte DAC-02 (dac02), Advantech PCL-733 (pcl733) and
@@ -597,7 +544,6 @@ endif # COMEDI_ISA_DRIVERS
 menuconfig COMEDI_PCI_DRIVERS
 	tristate "Comedi PCI drivers"
 	depends on COMEDI && PCI
-	default N
 	---help---
 	  Enable comedi PCI drivers to be built
 
@@ -610,7 +556,6 @@ if COMEDI_PCI_DRIVERS && PCI
 config COMEDI_ADDI_APCI_035
 	tristate "ADDI-DATA APCI_035 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_035 cards
 
@@ -620,7 +565,6 @@ config COMEDI_ADDI_APCI_035
 config COMEDI_ADDI_APCI_1032
 	tristate "ADDI-DATA APCI_1032 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_1032 cards
 
@@ -630,7 +574,6 @@ config COMEDI_ADDI_APCI_1032
 config COMEDI_ADDI_APCI_1500
 	tristate "ADDI-DATA APCI_1500 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_1500 cards
 
@@ -640,7 +583,6 @@ config COMEDI_ADDI_APCI_1500
 config COMEDI_ADDI_APCI_1516
 	tristate "ADDI-DATA APCI_1516 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_1516 cards
 
@@ -650,7 +592,6 @@ config COMEDI_ADDI_APCI_1516
 config COMEDI_ADDI_APCI_1564
 	tristate "ADDI-DATA APCI_1564 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_1564 cards
 
@@ -660,7 +601,6 @@ config COMEDI_ADDI_APCI_1564
 config COMEDI_ADDI_APCI_16XX
 	tristate "ADDI-DATA APCI_16xx support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_16xx cards
 
@@ -670,7 +610,6 @@ config COMEDI_ADDI_APCI_16XX
 config COMEDI_ADDI_APCI_2016
 	tristate "ADDI-DATA APCI_2016 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_2016 cards
 
@@ -680,7 +619,6 @@ config COMEDI_ADDI_APCI_2016
 config COMEDI_ADDI_APCI_2032
 	tristate "ADDI-DATA APCI_2032 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_2032 cards
 
@@ -690,7 +628,6 @@ config COMEDI_ADDI_APCI_2032
 config COMEDI_ADDI_APCI_2200
 	tristate "ADDI-DATA APCI_2200 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_2200 cards
 
@@ -701,7 +638,6 @@ config COMEDI_ADDI_APCI_3001
 	tristate "ADDI-DATA APCI_3001 support"
 	depends on VIRT_TO_BUS
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_3001 cards
 
@@ -712,7 +648,6 @@ config COMEDI_ADDI_APCI_3120
 	tristate "ADDI-DATA APCI_3520 support"
 	depends on VIRT_TO_BUS
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_3520 cards
 
@@ -722,7 +657,6 @@ config COMEDI_ADDI_APCI_3120
 config COMEDI_ADDI_APCI_3501
 	tristate "ADDI-DATA APCI_3501 support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_3501 cards
 
@@ -732,7 +666,6 @@ config COMEDI_ADDI_APCI_3501
 config COMEDI_ADDI_APCI_3XXX
 	tristate "ADDI-DATA APCI_3xxx support"
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADDI-DATA APCI_3xxx cards
 
@@ -742,7 +675,6 @@ config COMEDI_ADDI_APCI_3XXX
 config COMEDI_ADL_PCI6208
 	tristate "ADLink PCI-6208A support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for ADLink PCI-6208A cards
 
@@ -751,7 +683,6 @@ config COMEDI_ADL_PCI6208
 
 config COMEDI_ADL_PCI7230
 	tristate "ADLink PCI-7230 digital io board support"
-	default N
 	---help---
 	  Enable support for ADlink PCI-7230 digital io board support
 
@@ -760,7 +691,6 @@ config COMEDI_ADL_PCI7230
 
 config COMEDI_ADL_PCI7296
 	tristate "ADLink PCI-7296 96 ch. digital io board support"
-	default N
 	---help---
 	  Enable support for ADlink PCI-7296 96 ch. digital io board support
 
@@ -769,7 +699,6 @@ config COMEDI_ADL_PCI7296
 
 config COMEDI_ADL_PCI7432
 	tristate "ADLink PCI-7432 64 ch. isolated digital io board support"
-	default N
 	---help---
 	  Enable support for ADlink PCI-7432 64 ch. isolated digital io board
 
@@ -778,7 +707,6 @@ config COMEDI_ADL_PCI7432
 
 config COMEDI_ADL_PCI8164
 	tristate "ADLink PCI-8164 4 Axes Motion Control board support"
-	default N
 	---help---
 	  Enable support for ADlink PCI-8164 4 Axes Motion Control board
 
@@ -788,7 +716,6 @@ config COMEDI_ADL_PCI8164
 config COMEDI_ADL_PCI9111
 	tristate "ADLink PCI-9111HR support"
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for ADlink PCI9111 cards
 
@@ -799,7 +726,6 @@ config COMEDI_ADL_PCI9118
 	tristate "ADLink PCI-9118DG, PCI-9118HG, PCI-9118HR support"
 	select COMEDI_FC
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for ADlink PCI-9118DG, PCI-9118HG, PCI-9118HR cards
 
@@ -808,7 +734,6 @@ config COMEDI_ADL_PCI9118
 
 config COMEDI_ADV_PCI1710
 	tristate "Advantech PCI-171x, PCI-1720 and PCI-1731 support"
-	default N
 	---help---
 	  Enable support for Advantech PCI-1710, PCI-1710HG, PCI-1711,
 	  PCI-1713, PCI-1720 and PCI-1731
@@ -818,7 +743,6 @@ config COMEDI_ADV_PCI1710
 
 config COMEDI_ADV_PCI1723
 	tristate "Advantech PCI-1723 support"
-	default N
 	---help---
 	  Enable support for Advantech PCI-1723 cards
 
@@ -828,7 +752,6 @@ config COMEDI_ADV_PCI1723
 config COMEDI_ADV_PCI_DIO
 	tristate "Advantech PCI DIO card support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for Advantech PCI DIO cards
 	  PCI-1730, PCI-1733, PCI-1734, PCI-1735U, PCI-1736UP, PCI-1739U,
@@ -841,7 +764,6 @@ config COMEDI_ADV_PCI_DIO
 config COMEDI_AMPLC_DIO200_PCI
 	tristate "Amplicon PCI215 and PCI272 DIO board support"
 	select COMEDI_AMPLC_DIO200
-	default N
 	---help---
 	  Enable support for Amplicon PCI215 and PCI272 DIO boards.
 
@@ -851,7 +773,6 @@ config COMEDI_AMPLC_DIO200_PCI
 config COMEDI_AMPLC_PC236_PCI
 	tristate "Amplicon PCI236 DIO board support"
 	select COMEDI_AMPLC_PC236
-	default N
 	---help---
 	  Enable support for Amplicon PCI236 DIO board.
 
@@ -861,7 +782,6 @@ config COMEDI_AMPLC_PC236_PCI
 config COMEDI_AMPLC_PC263_PCI
 	tristate "Amplicon PCI263 relay board support"
 	select COMEDI_AMPLC_PC263
-	default N
 	---help---
 	  Enable support for Amplicon PCI263 relay board.
 
@@ -871,7 +791,6 @@ config COMEDI_AMPLC_PC263_PCI
 config COMEDI_AMPLC_PCI224
 	tristate "Amplicon PCI224 and PCI234 support"
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for Amplicon PCI224 and PCI234 AO boards
 
@@ -881,7 +800,6 @@ config COMEDI_AMPLC_PCI224
 config COMEDI_AMPLC_PCI230
 	tristate "Amplicon PCI230 and PCI260 support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for Amplicon PCI230 and PCI260 Multifunction I/O
 	  boards
@@ -891,7 +809,6 @@ config COMEDI_AMPLC_PCI230
 
 config COMEDI_CONTEC_PCI_DIO
 	tristate "Contec PIO1616L digital I/O board support"
-	default N
 	---help---
 	  Enable support for the Contec PIO1616L digital I/O board
 
@@ -901,7 +818,6 @@ config COMEDI_CONTEC_PCI_DIO
 config COMEDI_DAS08_PCI
 	tristate "DAS-08 PCI support"
 	select COMEDI_DAS08
-	default N
 	---help---
 	  Enable support for PCI DAS-08 cards.
 
@@ -910,7 +826,6 @@ config COMEDI_DAS08_PCI
 
 config COMEDI_DT3000
 	tristate "Data Translation DT3000 series support"
-	default N
 	---help---
 	  Enable support for Data Translation DT3000 series
 	  DT3001, DT3001-PGL, DT3002, DT3003, DT3003-PGL, DT3004, DT3005 and
@@ -921,7 +836,6 @@ config COMEDI_DT3000
 
 config COMEDI_DYNA_PCI10XX
 	tristate "Dynalog PCI DAQ series support"
-	default N
 	---help---
 	  Enable support for Dynalog PCI DAQ series
 	  PCI-1050
@@ -931,7 +845,6 @@ config COMEDI_DYNA_PCI10XX
 
 config COMEDI_UNIOXX5
 	tristate "Fastwel UNIOxx-5 analog and digital io board support"
-	default N
 	---help---
 	  Enable support for Fastwel UNIOxx-5 (analog and digital i/o) boards
 
@@ -941,7 +854,6 @@ config COMEDI_UNIOXX5
 config COMEDI_GSC_HPDI
 	tristate "General Standards PCI-HPDI32 / PMC-HPDI32 support"
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for General Standards Corporation high speed parallel
 	  digital interface rs485 boards PCI-HPDI32 and PMC-HPDI32.
@@ -952,7 +864,6 @@ config COMEDI_GSC_HPDI
 
 config COMEDI_ICP_MULTI
 	tristate "Inova ICP_MULTI support"
-	default N
 	---help---
 	  Enable support for Inova ICP_MULTI card
 
@@ -961,7 +872,6 @@ config COMEDI_ICP_MULTI
 
 config COMEDI_II_PCI20KC
 	tristate "Intelligent Instruments PCI-20001C carrier support"
-	default N
 	---help---
 	  Enable support for Intelligent Instruments PCI-20001C carrier
 	  PCI-20001, PCI-20006 and PCI-20341
@@ -972,7 +882,6 @@ config COMEDI_II_PCI20KC
 config COMEDI_DAQBOARD2000
 	tristate "IOtech DAQboard/2000 support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for the IOtech DAQboard/2000
 
@@ -981,7 +890,6 @@ config COMEDI_DAQBOARD2000
 
 config COMEDI_JR3_PCI
 	tristate "JR3/PCI force sensor board support"
-	default N
 	---help---
 	  Enable support for JR3/PCI force sensor boards
 
@@ -990,7 +898,6 @@ config COMEDI_JR3_PCI
 
 config COMEDI_KE_COUNTER
 	tristate "Kolter-Electronic PCI Counter 1 card support"
-	default N
 	---help---
 	  Enable support for Kolter-Electronic PCI Counter 1 cards
 
@@ -1001,7 +908,6 @@ config COMEDI_CB_PCIDAS64
 	tristate "MeasurementComputing PCI-DAS 64xx, 60xx, and 4020 support"
 	select COMEDI_8255
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DAS 64xx,
 	  60xx, and 4020 series with the PLX 9080 PCI controller
@@ -1013,7 +919,6 @@ config COMEDI_CB_PCIDAS
 	tristate "MeasurementComputing PCI-DAS support"
 	select COMEDI_8255
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DAS with
 	  AMCC S5933 PCIcontroller: PCI-DAS1602/16, PCI-DAS1602/16jr,
@@ -1026,7 +931,6 @@ config COMEDI_CB_PCIDAS
 config COMEDI_CB_PCIDDA
 	tristate "MeasurementComputing PCI-DDA series support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DDA
 	  series: PCI-DDA08/12, PCI-DDA04/12, PCI-DDA02/12, PCI-DDA08/16,
@@ -1038,7 +942,6 @@ config COMEDI_CB_PCIDDA
 config COMEDI_CB_PCIDIO
 	tristate "MeasurementComputing PCI-DIO series support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DIO series
 	  PCI-DIO24, PCI-DIO24H and PCI-DIO48H
@@ -1049,7 +952,6 @@ config COMEDI_CB_PCIDIO
 config COMEDI_CB_PCIMDAS
 	tristate "MeasurementComputing PCIM-DAS1602/16 support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI Migration
 	  series PCIM-DAS1602/16
@@ -1060,7 +962,6 @@ config COMEDI_CB_PCIMDAS
 config COMEDI_CB_PCIMDDA
 	tristate "MeasurementComputing PCIM-DDA06-16 support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCIM-DDA06-16
 
@@ -1069,7 +970,6 @@ config COMEDI_CB_PCIMDDA
 
 config COMEDI_ME4000
 	tristate "Meilhaus ME-4000 support"
-	default N
 	---help---
 	  Enable support for Meilhaus PCI data acquisition cards
 	  ME-4650, ME-4670i, ME-4680, ME-4680i and ME-4680is
@@ -1079,7 +979,6 @@ config COMEDI_ME4000
 
 config COMEDI_ME_DAQ
 	tristate "Meilhaus ME-2000i, ME-2600i, ME-3000vm1 support"
-	default N
 	---help---
 	  Enable support for Meilhaus PCI data acquisition cards
 	  ME-2000i, ME-2600i and ME-3000vm1
@@ -1090,7 +989,6 @@ config COMEDI_ME_DAQ
 config COMEDI_NI_6527
 	tristate "NI 6527 support"
 	depends on COMEDI_MITE
-	default N
 	---help---
 	  Enable support for the National Instruments 6527 PCI card
 
@@ -1100,7 +998,6 @@ config COMEDI_NI_6527
 config COMEDI_NI_65XX
 	tristate "NI 65xx static dio PCI card support"
 	depends on COMEDI_MITE
-	default N
 	---help---
 	  Enable support for National Instruments 65xx static dio boards.
 	  Supported devices: National Instruments PCI-6509 (ni_65xx),
@@ -1114,7 +1011,6 @@ config COMEDI_NI_65XX
 config COMEDI_NI_660X
 	tristate "NI 660x counter/timer PCI card support"
 	depends on COMEDI_NI_TIO && COMEDI_NI_COMMON
-	default N
 	---help---
 	  Enable support for National Instruments PCI-6601 (ni_660x), PCI-6602,
 	  PXI-6602 and PXI-6608.
@@ -1125,7 +1021,6 @@ config COMEDI_NI_660X
 config COMEDI_NI_670X
 	tristate "NI 670x PCI card support"
 	depends on COMEDI_MITE
-	default N
 	---help---
 	  Enable support for National Instruments PCI-6703 and PCI-6704
 
@@ -1136,7 +1031,6 @@ config COMEDI_NI_PCIDIO
 	tristate "NI PCI-DIO32HS, PCI-DIO96, PCI-6533, PCI-6503 support"
 	depends on COMEDI_MITE
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for National Instruments PCI-DIO-32HS, PXI-6533,
 	  PCI-DIO-96, PCI-DIO-96B, PXI-6508, PCI-6503, PCI-6503B, PCI-6503X,
@@ -1152,7 +1046,6 @@ config COMEDI_NI_PCIMIO
 	depends on COMEDI_NI_TIO && COMEDI_NI_COMMON
 	select COMEDI_8255
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for National Instruments PCI-MIO-E series and M series
 	  (all boards): PCI-MIO-16XE-10, PXI-6030E, PCI-MIO-16E-1,
@@ -1171,7 +1064,6 @@ config COMEDI_NI_PCIMIO
 config COMEDI_RTD520
 	tristate "Real Time Devices PCI4520/DM7520 support"
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for Real Time Devices PCI4520/DM7520
 
@@ -1180,7 +1072,6 @@ config COMEDI_RTD520
 
 config COMEDI_S526
 	tristate "Sensoray s526 support"
-	default N
 	---help---
 	  Enable support for Sensoray s526
 
@@ -1190,7 +1081,6 @@ config COMEDI_S526
 config COMEDI_S626
 	tristate "Sensoray 626 support"
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for Sensoray 626
 
@@ -1199,7 +1089,6 @@ config COMEDI_S626
 
 config COMEDI_SSV_DNP
 	tristate "SSV Embedded Systems DIL/Net-PC support"
-	default N
 	---help---
 	  Enable support for SSV Embedded Systems DIL/Net-PC
 
@@ -1211,7 +1100,6 @@ endif # COMEDI_PCI_DRIVERS
 menuconfig COMEDI_PCMCIA_DRIVERS
 	tristate "Comedi PCMCIA drivers"
 	depends on COMEDI && (PCMCIA || PCCARD)
-	default N
 	---help---
 	  Enable comedi PCMCIA and PCCARD drivers to be built
 
@@ -1223,7 +1111,6 @@ if COMEDI_PCMCIA_DRIVERS && PCMCIA
 
 config COMEDI_CB_DAS16_CS
 	tristate "CB DAS16 series PCMCIA support"
-	default N
 	---help---
 	  Enable support for the ComputerBoards/MeasurementComputing PCMCIA
 	  cards DAS16/16, PCM-DAS16D/12 and PCM-DAS16s/16
@@ -1234,7 +1121,6 @@ config COMEDI_CB_DAS16_CS
 config COMEDI_DAS08_CS
 	tristate "CB DAS08 PCMCIA support"
 	select COMEDI_DAS08
-	default N
 	---help---
 	  Enable support for the ComputerBoards/MeasurementComputing DAS-08
 	  PCMCIA card
@@ -1245,7 +1131,6 @@ config COMEDI_DAS08_CS
 config COMEDI_NI_DAQ_700_CS
 	tristate "NI DAQCard-700 PCMCIA support"
 	depends on COMEDI_NI_COMMON
-	default N
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQCard-700 DIO
 
@@ -1256,7 +1141,6 @@ config COMEDI_NI_DAQ_DIO24_CS
 	tristate "NI DAQ-Card DIO-24 PCMCIA support"
 	depends on COMEDI_NI_COMMON
 	select COMEDI_8255
-	default N
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQ-Card DIO-24
 
@@ -1266,7 +1150,6 @@ config COMEDI_NI_DAQ_DIO24_CS
 config COMEDI_NI_LABPC_CS
 	tristate "NI DAQCard-1200 PCMCIA support"
 	depends on COMEDI_NI_LABPC
-	default N
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQCard-1200
 
@@ -1278,7 +1161,6 @@ config COMEDI_NI_MIO_CS
 	depends on COMEDI_NI_TIO && COMEDI_NI_COMMON
 	select COMEDI_8255
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQCard E series
 	  DAQCard-ai-16xe-50, DAQCard-ai-16e-4, DAQCard-6062E, DAQCard-6024E
@@ -1289,7 +1171,6 @@ config COMEDI_NI_MIO_CS
 
 config COMEDI_QUATECH_DAQP_CS
 	tristate "Quatech DAQP PCMCIA data capture card support"
-	default N
 	---help---
 	  Enable support for the Quatech DAQP PCMCIA data capture cards
 	  DAQP-208 and DAQP-308
@@ -1302,7 +1183,6 @@ endif # COMEDI_PCMCIA_DRIVERS
 menuconfig COMEDI_USB_DRIVERS
 	tristate "Comedi USB drivers"
 	depends on COMEDI && USB
-	default N
 	---help---
 	  Enable comedi USB drivers to be built
 
@@ -1314,7 +1194,6 @@ if COMEDI_USB_DRIVERS && USB
 
 config COMEDI_DT9812
 	tristate "DataTranslation DT9812 USB module support"
-	default N
 	---help---
 	  Enable support for the Data Translation DT9812 USB module
 
@@ -1323,7 +1202,6 @@ config COMEDI_DT9812
 
 config COMEDI_USBDUX
 	tristate "ITL USB-DUX-D support"
-	default N
 	---help---
 	  Enable support for the Incite Technology Ltd USB-DUX-D Board
 
@@ -1333,7 +1211,6 @@ config COMEDI_USBDUX
 config COMEDI_USBDUXFAST
 	tristate "ITL USB-DUXfast support"
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for the Incite Technology Ltd USB-DUXfast Board
 
@@ -1343,7 +1220,6 @@ config COMEDI_USBDUXFAST
 config COMEDI_USBDUXSIGMA
 	tristate "ITL USB-DUXsigma support"
 	select COMEDI_FC
-	default N
 	---help---
 	  Enable support for the Incite Technology Ltd USB-DUXsigma Board
 
@@ -1352,7 +1228,6 @@ config COMEDI_USBDUXSIGMA
 
 config COMEDI_VMK80XX
 	tristate "Velleman VM110/VM140 USB Board support"
-	default N
 	---help---
 	  Build the Velleman USB Board Low-Level Driver supporting the
 	  K8055/K8061 aka VM110/VM140 devices
@@ -1365,7 +1240,6 @@ endif # COMEDI_USB_DRIVERS
 menuconfig COMEDI_NI_COMMON
 	tristate "Comedi National Instruments card support"
 	depends on COMEDI
-	default N
 	---help---
 	  Enable comedi support for National Instruments cards.
 	  Modules in this section are used by many comedi NI drivers.
@@ -1379,7 +1253,6 @@ if COMEDI_NI_COMMON
 config COMEDI_MITE
 	tristate "NI Mite PCI interface chip support"
 	depends on PCI
-	default N
 	---help---
 	  Enable support for National Instruments Mite PCI interface chip
 
@@ -1389,7 +1262,6 @@ config COMEDI_MITE
 config COMEDI_NI_TIO
 	tristate "NI general purpose counter support"
 	depends on COMEDI_MITE
-	default N
 	---help---
 	  Enable support for National Instruments general purpose counters.
 	  This module is not used directly by end-users. Rather, it
@@ -1405,7 +1277,6 @@ config COMEDI_NI_LABPC
 	select COMEDI_8255
 	select COMEDI_FC
 	depends on VIRT_TO_BUS
-	default N
 	---help---
 	  Enable support for National Instruments Lab-PC and compatibles
 	  Lab-PC-1200, Lab-PC-1200AI, Lab-PC+ and PCI-1200.
@@ -1420,7 +1291,6 @@ endif # COMEDI_NI_COMMON
 config COMEDI_8255
 	tristate "Generic 8255 support"
 	depends on COMEDI
-	default N
 	---help---
 	  Enable generic 8255 support.
 
@@ -1437,7 +1307,6 @@ config COMEDI_8255
 config COMEDI_FC
 	tristate "Comedi shared functions for low-level driver support"
 	depends on COMEDI
-	default N
 	---help---
 	  Enable support for shared functions for low-level drivers.
 	  This module is not used directly by end-users. Rather, it
@@ -1447,20 +1316,20 @@ config COMEDI_FC
 	  called comedi_fc.
 
 config COMEDI_AMPLC_DIO200
-	def_tristate N
+	tristate
 	depends on COMEDI
 	select COMEDI_8255
 
 config COMEDI_AMPLC_PC236
-	def_tristate N
+	tristate
 	depends on COMEDI
 	select COMEDI_8255
 
 config COMEDI_AMPLC_PC263
-	def_tristate N
+	tristate
 	depends on COMEDI
 
 config COMEDI_DAS08
-	def_tristate N
+	tristate
 	depends on COMEDI
 	select COMEDI_8255
