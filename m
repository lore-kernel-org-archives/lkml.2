Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab0IIWex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:34:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59296 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab0IIWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NslgVBzK8j70Q6m983OV27gPNwFp2KZSWro5jnelqlbIyQwkSUGbd87CQak354z8b7
         ZQvO/4kziUZvYwBEe4ByZA6Sog2gsTaCPfy/EsclxBeVSz+K2md19ANaIBzRCau8EA6x
         c0OQTkbOzXn/Ygh+pSrjQx5bbfKBKWodRhGUY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 104/223]drivers/net/atp.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:35:02 -0700
Message-Id: <1284071703-7996-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071703-7996-1-git-send-email-justinmattock@gmail.com>
References: <1284071703-7996-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/atp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atp.c b/drivers/net/atp.c
index bd2f9d3..7219604 100644
--- a/drivers/net/atp.c
+++ b/drivers/net/atp.c
@@ -68,7 +68,7 @@ static int xcvr[NUM_UNITS]; 			/* The data transfer mode. */
 
 	In 1997 Realtek made available the documentation for the second generation
 	RTL8012 chip, which has lead to several driver improvements.
-	  http://www.realtek.com.tw/cn/cn.html
+	 http://www.realtek.com.tw/ 
 
 					Theory of Operation
 
-- 
1.7.2.1

