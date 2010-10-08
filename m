Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0JHACq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab0JHACn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iZ1O1X97beoHNL22bKoYMC3En2zbbJAggxtoVwdYFUkL36TYP+Jd3nn5CfXtkC6bIg
         EdX6cAtkS9YXe6U0VhD3JClC+epR4iK8pGCBSQ96aIXstfUTDCRroWWz8cMh+lYO3/GI
         dkVfvRDNsM3/neDt+S7VaG8Jegz5xloufVNus=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 30/33] Staging: winbond: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:50 -0400
Message-Id: <1286496113-11897-30-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/winbond/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/winbond/Makefile b/drivers/staging/winbond/Makefile
index fb2b7d4..79fa227 100644
--- a/drivers/staging/winbond/Makefile
+++ b/drivers/staging/winbond/Makefile
@@ -1,4 +1,4 @@
-w35und-objs :=			\
+w35und-y :=			\
 	mds.o			\
 	mlmetxrx.o		\
 	mto.o			\
-- 
1.7.3.1.50.g1e633

