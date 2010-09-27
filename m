Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0I0AAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:00:05 -0400
Received: from vana.uk.cvut.cz ([147.32.245.124]:47777 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab0I0AAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:00:03 -0400
X-Greylist: delayed 747 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Sep 2010 20:00:03 EDT
Date: Mon, 27 Sep 2010 02:00:01 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Update matroxfb & ncpfs status
Message-ID: <20100927000001.GB31884@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update matroxfb & ncpfs status

I've moved couple years ago, so let's update my email and snail mail.

And I do not have any access to Matrox hardware anymore, and I'm quite
unresponsive to matroxfb bug reports (sorry Alan), so saying that I'm
maintainer is a bit far fetched.

For ncpfs I do not use ncpfs in my daily life either, but at least
I can test that one, so I can stay listed here for odd fixes.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

diff --git a/CREDITS b/CREDITS
index 72b4878..41d8e63 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3554,12 +3554,12 @@ E: cvance@nai.com
 D: portions of the Linux Security Module (LSM) framework and security modules
 
 N: Petr Vandrovec
-E: vandrove@vc.cvut.cz
+E: petr@vandrovec.name
 D: Small contributions to ncpfs
 D: Matrox framebuffer driver
-S: Chudenicka 8
-S: 10200 Prague 10, Hostivar
-S: Czech Republic
+S: 21513 Conradia Ct
+S: Cupertino, CA 95014
+S: USA
 
 N: Thibaut Varene
 E: T-Bone@parisc-linux.org
diff --git a/MAINTAINERS b/MAINTAINERS
index 8540dea..a394a6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3773,9 +3773,8 @@ W:	http://www.syskonnect.com
 S:	Supported
 
 MATROX FRAMEBUFFER DRIVER
-M:	Petr Vandrovec <vandrove@vc.cvut.cz>
 L:	linux-fbdev@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/video/matrox/matroxfb_*
 F:	include/linux/matroxfb.h
 
@@ -3962,8 +3961,8 @@ S:	Maintained
 F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
-M:	Petr Vandrovec <vandrove@vc.cvut.cz>
-S:	Maintained
+M:	Petr Vandrovec <petr@vandrovec.name>
+S:	Odd Fixes
 F:	fs/ncpfs/
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
