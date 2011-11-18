Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1KRNLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:11:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45377 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1KRNLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:11:10 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: segoon@openwall.com
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH] Ipc: shm: fixed a brace coding style issue
Date: Fri, 18 Nov 2011 06:11:02 -0700
Message-Id: <1321621862-4875-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 ipc/shm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 02ecf2c..dfcf20d 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -88,7 +88,7 @@ static void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	struct shmid_kernel *shp;
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 
-	if (shp->shm_nattch){
+	if (shp->shm_nattch) {
 		shp->shm_perm.mode |= SHM_DEST;
 		/* Do not find it any more */
 		shp->shm_perm.key = IPC_PRIVATE;
-- 
1.7.7.3

