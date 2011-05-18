Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1ERVZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:25:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41817 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1ERVZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gchsjzHhYimH/2JxF5h/X64SzLEx/9SmgIYnjFen/irb4ISmRh911zJhw3vxO+8CaP
         SA+zAuo7RXDsP+JF4Y1NGVZvSwd786SdbRmlwb/vqvrUAdiGnrZ7N5zQR9PU/qc4ETXF
         X8eKMZvQtA1ZGKbf1DfYHeQLSdVQNrjQEGBRg=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 1/7] [RFC] Mainline BG/P platform support
Date: Wed, 18 May 2011 16:24:49 -0500
Message-Id: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel patches for the IBM BlueGene/P have been open-sourced
for quite some time, but haven't been integrated into the mainline Linux
kernel source tree.  This is the first patch series of several where I
will attempt to cleanup and mainline the already public patches.  I
welcome feedback as well as any help I can get.  I'm drawing on
the patches available for the IBM Compute Node kernel, the ZeptoOS project
and the Kittyhawk project.
(all available from http://wiki.bg.anl-external.org)

I'll be prioritizing core patches which are harder to keep current with
mainline due to merge conflicts and then slowly incorporating the drivers
and other extensions (if acceptable after community review).

I'll be maintaining the patchset in my kernel.org repository
(/pub/scm/linux/kernel/git/ericvh/bluegene.git) under the bluegene
branch with the source repos (zepto, kittyhawk, ibmcn) available in
respective branches.  Ben - if you would prefer me to send pull requests
once we get rolling, I can switch to that -- otherwise I'll stick to
just submitting patches to the list assuming you'll pull them when they
become acceptable.  Thanks for your attention reviewing these patches.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 69f19f1..3ffca88 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3863,6 +3863,14 @@ S:	Maintained
 F:	arch/powerpc/platforms/40x/
 F:	arch/powerpc/platforms/44x/
 
+LINUX FOR POWERPC BLUEGENE/P
+M:	Eric Van Hensbergen <ericvh@gmail.com>
+W:	http://bg-linux.anl-external.org/wiki/index.php/Main_Page
+L:	bg-linux@lists.anl-external.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/bluegene.git
+S:	Maintained
+F:	arch/powerpc/platforms/44x/bgp*
+
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
 M:	Grant Likely <grant.likely@secretlab.ca>
 W:	http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
-- 
1.7.4.1

