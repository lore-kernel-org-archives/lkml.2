Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1EIOW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:22:27 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:61679 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1EIOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=gO87izmwGd1c8qXcTUPLI4bAGc71iaKGvM4XNTlBx4pbXcN2sJuj+2CPSzVPnI3Apd
         sLVLPXuIbR91gcmVGA+FF8TSj4ZuQvLv8YXucy5VblBuFZrayg+FJirlQ5Vh1j0jPxbU
         h/0k3Lj+WIdhu2s6PpYlMZzN7jVbIbB2MQea0=
Date: Mon, 9 May 2011 22:16:30 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, joe@perches.com,
        greg@kroah.com
Subject: [PATCH]Take orders for MAINTAINERS file
Message-ID: <20110509141626.GA6174@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	davem@davemloft.net, joe@perches.com, greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

Take alphabetical orders for MAINTAINERS file.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |   80 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2199ba1..73b0d50 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2813,38 +2813,19 @@ F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
 
+GRE DEMULTIPLEXER DRIVER
+M:	Dmitry Kozlov <xeb@mail.ru>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	net/ipv4/gre.c
+F:	include/net/gre.h
+
 GRETH 10/100/1G Ethernet MAC device driver
 M:	Kristoffer Glembo <kristoffer@gaisler.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/greth*
 
-HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
-M:	Frank Seidel <frank@f-seidel.de>
-L:	platform-driver-x86@vger.kernel.org
-W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
-S:	Maintained
-F:	drivers/platform/x86/hdaps.c
-
-HWPOISON MEMORY FAILURE HANDLING
-M:	Andi Kleen <andi@firstfloor.org>
-L:	linux-mm@kvack.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
-S:	Maintained
-F:	mm/memory-failure.c
-F:	mm/hwpoison-inject.c
-
-HYPERVISOR VIRTUAL CONSOLE DRIVER
-L:	linuxppc-dev@lists.ozlabs.org
-S:	Odd Fixes
-F:	drivers/tty/hvc/
-
-iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
-M:	Peter Jones <pjones@redhat.com>
-M:	Konrad Rzeszutek Wilk <konrad@kernel.org>
-S:	Maintained
-F:	drivers/firmware/iscsi_ibft*
-
 GSPCA FINEPIX SUBDRIVER
 M:	Frank Zago <frank@zago.net>
 L:	linux-media@vger.kernel.org
@@ -2895,6 +2876,26 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/
 
+HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
+M:	Frank Seidel <frank@f-seidel.de>
+L:	platform-driver-x86@vger.kernel.org
+W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
+S:	Maintained
+F:	drivers/platform/x86/hdaps.c
+
+HWPOISON MEMORY FAILURE HANDLING
+M:	Andi Kleen <andi@firstfloor.org>
+L:	linux-mm@kvack.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
+S:	Maintained
+F:	mm/memory-failure.c
+F:	mm/hwpoison-inject.c
+
+HYPERVISOR VIRTUAL CONSOLE DRIVER
+L:	linuxppc-dev@lists.ozlabs.org
+S:	Odd Fixes
+F:	drivers/tty/hvc/
+
 HARDWARE MONITORING
 M:	Jean Delvare <khali@linux-fr.org>
 M:	Guenter Roeck <guenter.roeck@ericsson.com>
@@ -3478,6 +3479,12 @@ F:	Documentation/isapnp.txt
 F:	drivers/pnp/isapnp/
 F:	include/linux/isapnp.h
 
+iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
+M:	Peter Jones <pjones@redhat.com>
+M:	Konrad Rzeszutek Wilk <konrad@kernel.org>
+S:	Maintained
+F:	drivers/firmware/iscsi_ibft*
+
 ISCSI
 M:	Mike Christie <michaelc@cs.wisc.edu>
 L:	open-iscsi@googlegroups.com
@@ -4989,6 +4996,13 @@ F:	Documentation/pps/
 F:	drivers/pps/
 F:	include/linux/pps*.h
 
+PPTP DRIVER
+M:	Dmitry Kozlov <xeb@mail.ru>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/pptp.c
+W:	http://sourceforge.net/projects/accel-pptp
+
 PREEMPTIBLE KERNEL
 M:	Robert Love <rml@tech9.net>
 L:	kpreempt-tech@lists.sourceforge.net
@@ -7024,20 +7038,6 @@ M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
-GRE DEMULTIPLEXER DRIVER
-M:	Dmitry Kozlov <xeb@mail.ru>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	net/ipv4/gre.c
-F:	include/net/gre.h
-
-PPTP DRIVER
-M:	Dmitry Kozlov <xeb@mail.ru>
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	drivers/net/pptp.c
-W:	http://sourceforge.net/projects/accel-pptp
-
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
1.7.0.4

