Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2LKNVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:21:44 -0500
Received: from mo-p04-ob.rzone.de ([81.169.146.178]:15416 "EHLO
	mo-p04-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2LKNVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:21:43 -0500
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 08:21:43 EST
X-RZG-CLASS-ID: mo04
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9DbcbmpiO4kpRAxeDm4w==
Message-ID: <50C72FCC.8010401@hartkopp.net>
Date: Tue, 11 Dec 2012 14:06:20 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Linux 3.8-merge version information
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the automatically generated git version information is misleading in the
merge window, name the kernel in the merge window as 3.8-merge .

This 'merge' version information helps to not interfere with 3.7-stable git
versions in the bootloader (grub) selection until 3.8-rc1 is tagged.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

---

diff --git a/Makefile b/Makefile
index 540f7b2..1fd4bf4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
-PATCHLEVEL = 7
+PATCHLEVEL = 8
 SUBLEVEL = 0
-EXTRAVERSION =
+EXTRAVERSION = -merge
 NAME = Terrified Chipmunk

 # *DOCUMENTATION*




