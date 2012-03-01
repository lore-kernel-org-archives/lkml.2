Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab2CAJ3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:29:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57580 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2CAJ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:29:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.231.228 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
MIME-Version: 1.0
Date: Thu, 1 Mar 2012 14:59:29 +0530
Message-ID: <CAOD=uF71cTJkKsEk4pyuN+JuP5Fw=_xDn0A5c_yob4paC6CJAA@mail.gmail.com>
Subject: Latest Kernel source Fail to Build
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am getting following error while building latest kernel source;

----------------------------------------------------------------------------------------
  OBJCOPY arch/x86/boot/vmlinux.bin
  HOSTCC  arch/x86/boot/tools/build
  BUILD   arch/x86/boot/bzImage
Setup is 14560 bytes (padded to 14848 bytes).
System is 3733 kB
CRC e5cc211e
Kernel: arch/x86/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 2253 modules
ERROR: "__udivdi3" [drivers/media/dvb/frontends/rtl2830.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
[root@localhost linux-next]#
-----------------------------------------------------------------------------------------------

I have downloaded the latest linux-next from kernel.org


regards
santosh
