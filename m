Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2AWB0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 20:26:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61752 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2AWB0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 20:26:19 -0500
Message-ID: <4F1CB737.3030701@gmail.com>
Date: Sun, 22 Jan 2012 17:26:15 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ERROR: "mc13xxx_parse_regulators_dt" [drivers/regulator/mc13892-regulator.ko]
 undefined!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is with using ubuntus generic .config

   CC      arch/x86/boot/main.o
   CC      arch/x86/boot/version.o
   CC      arch/x86/boot/apm.o
   CC      arch/x86/boot/video-vesa.o
   LD      arch/x86/boot/setup.elf
   OBJCOPY arch/x86/boot/setup.bin
   OBJCOPY arch/x86/boot/vmlinux.bin
   BUILD   arch/x86/boot/bzImage
Setup is 16752 bytes (padded to 16896 bytes).
System is 4587 kB
CRC 5d463dba
Kernel: arch/x86/boot/bzImage is ready  (#3)
   Building modules, stage 2.
   MODPOST 3362 modules
ERROR: "mc13xxx_parse_regulators_dt" 
[drivers/regulator/mc13892-regulator.ko] undefined!
ERROR: "mc13xxx_get_num_regulators_dt" 
[drivers/regulator/mc13892-regulator.ko] undefined!
WARNING: modpost: Found 26 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


Justin P. Mattock
