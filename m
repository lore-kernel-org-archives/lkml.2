Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0JHACn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab0JHACl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xReSOrhgKTywGyvVrxiwk5l/1d/wLEUQNsI0QRuhhVgfY0Oh+Es7W3P0cjCNkGp5va
         oWLuE7b46SXlyAn0zFhaAsug5nSCfGoul93C33eRv+88RTQwiNywe5e946mojiYRfRqz
         ChBFyMpefmZbiKIvxBlIQ7W3PngsUI9W1tXQ4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 28/33] Staging: tm6000: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:48 -0400
Message-Id: <1286496113-11897-28-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/tm6000/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/Makefile b/drivers/staging/tm6000/Makefile
index d8ccdaa..395515b 100644
--- a/drivers/staging/tm6000/Makefile
+++ b/drivers/staging/tm6000/Makefile
@@ -1,4 +1,4 @@
-tm6000-objs := tm6000-cards.o \
+tm6000-y := tm6000-cards.o \
 		   tm6000-core.o  \
 		   tm6000-i2c.o   \
 		   tm6000-video.o \
-- 
1.7.3.1.50.g1e633

