Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab2HCGfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:35:15 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:46481 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751272Ab2HCGfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:35:12 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.6-rc1:   apple-gmux  don't link, that mess the wole
 compilation because no vmlinuz produced
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 03 Aug 2012 02:35:08 -0400
Message-ID: <web-777101016@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      init/version.o
   LD      init/built-in.o
drivers/built-in.o: In function `gmux_probe':
apple-gmux.c:(.devinit.text+0x6daa8): undefined reference 
to `apple_bl_unregister'
drivers/built-in.o: In function `gmux_remove':
apple-gmux.c:(.devexit.text+0x8f80): undefined reference 
to `apple_bl_register'
make: [vmlinux] Error 1 (ignored)
   CC      arch/x86/boot/a20.o
   AS      arch/x86/boot/bioscall.o
   CC      arch/x86/boot/cmdline.o
   AS      arch/x86/boot/copy.o
   HOSTCC  arch/x86/boot/mkcpustr
   CPUSTR  arch/x86/boot/cpustr.h
   CC      arch/x86/boot/cpu.o
   CC      arch/x86/boot/cpucheck.o
   CC      arch/x86/boot/early_serial_console.o
   CC      arch/x86/boot/edd.o
make[1]: *** No rule to make target `vmlinux', needed by 
`arch/x86/boot/voffset.h'.
---
Professional hosting for everyone - http://www.host.ru
