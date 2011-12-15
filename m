Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab1LODXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:23:40 -0500
Received: from ozlabs.org ([203.10.76.45]:33140 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641Ab1LODXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: devel@driverdev.osuosl.org
Subject: [PATCH 6/15] lirc_parallel: fix module parameter description.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:36:22 +1030
Message-ID: <87vcpisfdd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cut and paste bug.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/staging/media/lirc/lirc_parallel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -752,4 +752,4 @@ module_param(debug, bool, S_IRUGO | S_IW
 MODULE_PARM_DESC(debug, "Enable debugging messages");
 
 module_param(check_pselecd, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Check for printer (default: 0)");
+MODULE_PARM_DESC(check_pselecd, "Check for printer (default: 0)");
