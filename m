Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0JHAHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:07:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab0JHACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x4glPROQ2rhZTbcq8Tnwmm1B7GXCarqKcB4Lrbb2nlgsnwKuuGEwktORYAXkoHmIir
         BlcGC/z0r4kSaXnAF0liE3RA0HH1e+vY+awn/jMipYp1GTo/I0QgFERzhCZGcHcrysEq
         Zacl/KvW9WYikEmIhKSQhYu/pFjENBDa7N1wQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 11/33] Staging: ft1000:ft1000-pcmia:  Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:31 -0400
Message-Id: <1286496113-11897-11-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/Makefile b/drivers/staging/ft1000/ft1000-pcmcia/Makefile
index 30ad208..660b7a5 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/Makefile
+++ b/drivers/staging/ft1000/ft1000-pcmcia/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_FT1000_PCMCIA) = ft1000_pcmcia.o
-ft1000_pcmcia-objs := ft1000_hw.o ft1000_dnld.o ft1000_proc.o ft1000_cs.o
+ft1000_pcmcia-y := ft1000_hw.o ft1000_dnld.o ft1000_proc.o ft1000_cs.o
 
-- 
1.7.3.1.50.g1e633

