Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab0KDNe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:34:26 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:33866 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab0KDNeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:34:24 -0400
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: document UTS_MACHINE environment variable
Date: Thu,  4 Nov 2010 13:34:11 +0000
Message-Id: <1288877651-7378-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UTS_MACHINE to the documentation of kbuild enviroment variables.
Description contributed by Michal Marek.

LKML-Reference: <4CD2A8BC.3010500@suse.cz>
Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
---
 Documentation/kbuild/kbuild.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 1e5165a..2d17361 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -89,6 +89,10 @@ CROSS_COMPILE can be a part of the filename or the full path.
 
 CROSS_COMPILE is also used for ccache in some setups.
 
+UTS_MACHINE
+--------------------------------------------------
+`uname -m` in the resulting kernel.
+
 CF
 --------------------------------------------------
 Additional options for sparse.
-- 
1.7.2.3

