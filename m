Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab2HDHRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 03:17:18 -0400
Received: from mail-yx0-f194.google.com ([209.85.213.194]:54022 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2HDHRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 03:17:16 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>,
        =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Subject: =?UTF-8?q?=5BPATCH=202/5=5D=20staging/csr=3A=20fix=20coding=20style=20problems=20in=20uf=5Fstop=5Fthread?=
Date: Sat,  4 Aug 2012 13:02:09 +0545
Message-Id: <1344064629-12211-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings and errors were fixed:

* fix no space at the start of a line
* fix line over 80 characters
* use tabs instead of spaces

Cc: Mikko Virkkilä <mikko.virkkila@bluegiga.com>
Cc: Lauri Hintsala <Lauri.Hintsala@bluegiga.com>
Cc: Riku Mettälä <riku.mettala@bluegiga.com>
Cc: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/csr/bh.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index 2b7c4c0..7a00aa8 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -94,15 +94,16 @@ int uf_start_thread(unifi_priv_t *priv,
  */
 void uf_stop_thread(unifi_priv_t *priv, struct uf_thread *thread)
 {
-    if (!thread->thread_task) {
-        unifi_notice(priv, "%s thread is already stopped\n", thread->name);
-        return;
-    }
+	if (!thread->thread_task) {
+		unifi_notice(priv, "%s thread is already stopped\n",
+							thread->name);
+		return;
+	}
 
-    unifi_trace(priv, UDBG2, "Stopping %s thread\n", thread->name);
+	unifi_trace(priv, UDBG2, "Stopping %s thread\n", thread->name);
 
-    kthread_stop(thread->thread_task);
-    thread->thread_task = NULL;
+	kthread_stop(thread->thread_task);
+	thread->thread_task = NULL;
 
 } /* uf_stop_thread() */
 
-- 
1.7.9.5

