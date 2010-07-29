Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab0G2JQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:16:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59533 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab0G2JQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bjCHnpqUHaQ5ndUMhlyJLSuwMR/Pai4y8V12aWgF98z3gLjSsqH6ySJJK3K8IGwEon
         hAVit463+oTv4PeL+yrvSiDoV1iYhY96SosEjqYoBIm7z39s+XhAUZZ8Lu64+FhZ1s8L
         m68fB3+K34z3PL5rsR5//15mfMjs4tfT7UknU=
From: Huang Shijie <shijie8@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH] update document
Date: Thu, 29 Jul 2010 17:18:25 +0800
Message-Id: <1280395105-4002-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	The exception.txt has been removed from the Documentation directory.
So update the index file for it.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 Documentation/00-INDEX |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 5405f7a..9e642c5 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -130,8 +130,6 @@ edac.txt
 	- information on EDAC - Error Detection And Correction
 eisa.txt
 	- info on EISA bus support.
-exception.txt
-	- how Linux v2.2 handles exceptions without verify_area etc.
 fault-injection/
 	- dir with docs about the fault injection capabilities infrastructure.
 fb/
-- 
1.6.6.1

