Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0JHACe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab0JHACb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T+QXhCJ8XjJ0o2QYO2lt50etXN2pZ3vliTHEMQsXO2jVB4cxkI86kU0o3AGKLOUG0B
         DQk1CzgSKYPklNFy/q7xrWJQSnDZxNeTEfN1gGjmVX/Uv2P8SLU0zEbyLst+E5KzeLDJ
         AzBVpRwZTK+XwMT9694K4DDvOGsjmrLPSZ/vA=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 22/33] Staging: rtl8712: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:42 -0400
Message-Id: <1286496113-11897-22-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8712/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/Makefile b/drivers/staging/rtl8712/Makefile
index 1ccd251..6f8500c 100644
--- a/drivers/staging/rtl8712/Makefile
+++ b/drivers/staging/rtl8712/Makefile
@@ -1,4 +1,4 @@
-r8712u-objs :=				\
+r8712u-y :=				\
 		rtl871x_cmd.o		\
 		rtl8712_cmd.o		\
 		rtl871x_security.o	\
-- 
1.7.3.1.50.g1e633

