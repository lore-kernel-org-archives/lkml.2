Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0GNSGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:06:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50565 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0GNSGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=t2kA5QaUIlQ6U5BzGMvPo5PdJcXkuMN4HUEBQDCL8clpW/pzPhWlGeqoLVf7RCVKY2
         nLNJU+aInpkvhvtXcg/PEGbAzaLi3nSkOtO4CbhlSCg/eamuheINMIG/E6/hUkudqPeh
         kKpZl48ggbWTIrakQF+iNShjbhIoR2auffBwg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Daniel Walker <dwalker@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] staging: msm: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:05:58 +0400
Message-Id: <1279130759-17608-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/msm/mdp4_overlay.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/msm/mdp4_overlay.c b/drivers/staging/msm/mdp4_overlay.c
index 304bb82..de284c2 100644
--- a/drivers/staging/msm/mdp4_overlay.c
+++ b/drivers/staging/msm/mdp4_overlay.c
@@ -874,8 +874,8 @@ struct mdp4_overlay_pipe *mdp4_overlay_pipe_alloc(void)
 		if (pipe->pipe_ndx == 0) {
 			pipe->pipe_ndx = i + 1;	/* start from 1 */
 			init_completion(&pipe->comp);
-	printk(KERN_INFO "mdp4_overlay_pipe_alloc: pipe=%x ndx=%d\n",
-					(int)pipe, pipe->pipe_ndx);
+	printk(KERN_INFO "mdp4_overlay_pipe_alloc: pipe=%p ndx=%d\n",
+					pipe, pipe->pipe_ndx);
 			return pipe;
 		}
 		pipe++;
@@ -887,8 +887,8 @@ struct mdp4_overlay_pipe *mdp4_overlay_pipe_alloc(void)
 
 void mdp4_overlay_pipe_free(struct mdp4_overlay_pipe *pipe)
 {
-	printk(KERN_INFO "mdp4_overlay_pipe_free: pipe=%x ndx=%d\n",
-					(int)pipe, pipe->pipe_ndx);
+	printk(KERN_INFO "mdp4_overlay_pipe_free: pipe=%p ndx=%d\n",
+					pipe, pipe->pipe_ndx);
 	memset(pipe, 0, sizeof(*pipe));
 }
 
-- 
1.7.0.4

