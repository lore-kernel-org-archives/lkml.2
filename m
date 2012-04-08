Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2DHW13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:27:29 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12206 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2DHW12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:27:28 -0400
Date: Mon, 9 Apr 2012 00:27:26 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
cc: trivial@kernel.org, Peter Gruber <nokos@gmx.net>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH][Trivial] sound/pci/riptide/riptide.c: remove trailing
 whitespace
Message-ID: <alpine.LNX.2.00.1204090024570.11747@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a bunch of trailing whitespace at the top of the
sound/pci/riptide/riptide.c file - this patch gets rid of it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/pci/riptide/riptide.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 0481d94..a8b07be 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -21,29 +21,29 @@
 /*
   History:
    - 02/15/2004 first release
-   
+
   This Driver is based on the OSS Driver version from Linuxant (riptide-0.6lnxtbeta03111100)
   credits from the original files:
-  
-  MODULE NAME:        cnxt_rt.h                       
+
+  MODULE NAME:        cnxt_rt.h
   AUTHOR:             K. Lazarev  (Transcribed by KNL)
   HISTORY:         Major Revision               Date        By
             -----------------------------     --------     -----
             Created                           02/1/2000     KNL
 
-  MODULE NAME:     int_mdl.c                       
+  MODULE NAME:     int_mdl.c
   AUTHOR:          Konstantin Lazarev    (Transcribed by KNL)
   HISTORY:         Major Revision               Date        By
             -----------------------------     --------     -----
             Created                           10/01/99      KNL
-	    
-  MODULE NAME:        riptide.h                       
+
+  MODULE NAME:        riptide.h
   AUTHOR:             O. Druzhinin  (Transcribed by OLD)
   HISTORY:         Major Revision               Date        By
             -----------------------------     --------     -----
             Created                           10/16/97      OLD
 
-  MODULE NAME:        Rp_Cmdif.cpp                       
+  MODULE NAME:        Rp_Cmdif.cpp
   AUTHOR:             O. Druzhinin  (Transcribed by OLD)
                       K. Lazarev    (Transcribed by KNL)
   HISTORY:         Major Revision               Date        By
@@ -51,7 +51,7 @@
             Adopted from NT4 driver            6/22/99      OLD
             Ported to Linux                    9/01/99      KNL
 
-  MODULE NAME:        rt_hw.c                       
+  MODULE NAME:        rt_hw.c
   AUTHOR:             O. Druzhinin  (Transcribed by OLD)
                       C. Lazarev    (Transcribed by CNL)
   HISTORY:         Major Revision               Date        By
@@ -73,13 +73,13 @@
             -----------------------------     --------     -----
             Created                           11/18/97      CNL
 
-  MODULE NAME:     rt_mdl.c                       
+  MODULE NAME:     rt_mdl.c
   AUTHOR:          Konstantin Lazarev    (Transcribed by KNL)
   HISTORY:         Major Revision               Date        By
             -----------------------------     --------     -----
             Created                           10/01/99      KNL
 
-  MODULE NAME:        mixer.h                        
+  MODULE NAME:        mixer.h
   AUTHOR:             K. Kenney
   HISTORY:         Major Revision                   Date          By
             -----------------------------          --------     -----
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

