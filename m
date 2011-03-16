Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1CPVMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:12:46 -0400
Received: from kroah.org ([198.145.64.141]:42583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab1CPVLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 12/50] dynamic_debug: add #include <linux/sched.h>
Date: Wed, 16 Mar 2011 14:10:50 -0700
Message-Id: <1300309888-5028-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build breakage caused by
8ba6ebf583f12da32036fc0f003ab4043e54692e "Dynamic debug: Add more flags"

Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dynamic_debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 863c834..75ca78f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/jump_label.h>
 #include <linux/hardirq.h>
+#include <linux/sched.h>
 
 extern struct _ddebug __start___verbose[];
 extern struct _ddebug __stop___verbose[];
-- 
1.7.4.1

