Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2LCKZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:25:13 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54024 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2LCKZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:25:11 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com,
        Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] tools:virtio: fix compilation warning
Date: Mon,  3 Dec 2012 10:24:54 +0000
Message-Id: <1354530294-10178-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not allow old-style function definition.  Always spell foo(void) if
a function does not take any parameters.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 tools/virtio/virtio_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index e626fa5..6d25dcd 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -232,7 +232,7 @@ const struct option longopts[] = {
 	}
 };
 
-static void help()
+static void help(void)
 {
 	fprintf(stderr, "Usage: virtio_test [--help]"
 		" [--no-indirect]"
-- 
1.7.4.5

