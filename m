Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0FXM26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:28:58 -0400
Received: from wipro-blr-out01.wipro.com ([203.91.198.74]:50595 "EHLO
	wipro-blr-out02.wipro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755249Ab0FXM2z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:28:55 -0400
X-AuditID: cb5bdd58-b7c47ae000007398-3e-4c234f85613b
From: <ganesh.patwardhan@wipro.com>
To: <linux-kernel@vger.kernel.org>
Date: Thu, 24 Jun 2010 17:57:45 +0530
Subject: kernel hangs
Thread-Topic: kernel hangs
Thread-Index: AQHLE5imZgxZ0+csiEK4W4lJSeNyaA==
Message-ID: <9B8CABFE337C3A41B83B3DB4D54F7A45017E64AEB8C9@BLR-SJP-MB01.wipro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 Jun 2010 12:28:52.0477 (UTC) FILETIME=[CE2662D0:01CB1398]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

         I have compiled linux-2.6.25 for MPC837X processor and generated "vmlinux.bin" image and then
          integrated this image with "rootfs" to generate "uSystem".(This is done using mkimage utility)
         Then downloaded this uSystem image in flash and tried to boot linux from u-boot. but linux hangs  at
         "Transferring control to Linux (at address 00000000)"
         .....please refer log below.

         If you have any idea due to what this problem may occur, please help me.

------------------------------------------------
boot log :
------------------------------------------------
bootm 0xfc100000
*  kernel: cmdline image address = 0xfc100000
## Booting kernel from Legacy Image at fc100000 ...
   Image Name:   linux-2.6
   Image Type:   PowerPC Linux Multi-File Image (gzip compressed)
   Data Size:    2857358 Bytes =  2.7 MB
   Load Address: 00000000
   Entry Point:  00000000
   Contents:
      Image 0: 1595336 Bytes =  1.5 MB
      Image 1: 1262010 Bytes =  1.2 MB
   Verifying Checksum ... OK
   kernel data at 0xfc10004c, len = 0x001857c8 (1595336)
   Uncompressing Multi-File Image ... OK
   kernel loaded at 0x00000000, end = 0x0031f9c0
## Current stack ends at 0x0ff41c70
## Flattened Device Tree from multi component Image at FC100000
## No Flattened Device Tree
## cmdline at 0x007fff00 ... 0x007fff00
## kernel board info at 0x007ffeb0
bd address  = 0x0FF41FBC
memstart    = 0x00000000
memsize     = 0x10000000
flashstart  = 0xFC000000
flashsize   = 0x04000000
flashoffset = 0x00032000
sramstart   = 0x00000000
sramsize    = 0x00000000
bootflags   = 0x00000001
intfreq     = 533.333 MHz
busfreq     = 266.666 MHz
ethaddr     = 00:00:00:00:00:00
eth1addr    = 00:04:9F:EF:04:02
IP addr     = 10.0.0.2
baudrate    = 115200 bps
## Loading init Ramdisk from multi component Legacy Image at fc100000 ...
   ramdisk start = 0xfc285814, ramdisk end = 0xfc3b99ce
## initrd_high = 0xffffffff, copy_to_ram = 1
   Loading Ramdisk to 0fe0d000, end 0ff411ba ... OK
   ramdisk load start = 0x0fe0d000, ramdisk load end = 0x0ff411ba
## Transferring control to Linux (at address 00000000) ...

        


Regards
Ganesh Patwardhan