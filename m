Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750933Ab2AOPWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 10:22:24 -0500
Received: from snt0-omc1-s52.snt0.hotmail.com ([65.54.61.89]:17402 "EHLO
	snt0-omc1-s52.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab2AOPWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:22:23 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jan 2012 10:22:23 EST
Message-ID: <SNT144-W1DC10F59BB90518BD3FBFDF820@phx.gbl>
X-Originating-IP: [76.193.174.224]
From: Jason Dravet <dravet@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] clarify WARNING: at fs/sysfs/dir.c:481 sysfs_add
Date: Sun, 15 Jan 2012 09:16:13 -0600
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 15 Jan 2012 15:16:13.0846 (UTC) FILETIME=[9EBB3360:01CCD398]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch makes it clear that the problem is in the BIOS of the computer and not the kernel.  This patch applies to kernel 3.2.1.
 
Reported-by: Greg White <pcguy11@live.com>
Signed-off-by: Jason Dravet <dravet@hotmail.com>
Tested-by: Greg White <pcguy11@live.com>
 
--- dir.orig    2012-01-14 18:58:20.026745884 -0600
+++ dir.c    2012-01-14 19:52:33.011444581 -0600
@@ -479,6 +479,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt
              (path == NULL) ? sd->s_name :
              strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
                     sd->s_name));
+        WARN(1, KERN_WARNING
+             "Your BIOS is broken.  Please contact your computer manufacturer.");
         kfree(path);
     }
 
 

 		 	   		  