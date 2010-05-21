Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab0EUQ5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:57:41 -0400
Received: from kroah.org ([198.145.64.141]:39165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934269Ab0EUQyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Egger <siccegge@cs.fau.de>, Mark McLoughlin <markmc@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/38] driver-core: fix Typo in drivers/base/core.c for CONFIG_MODULE
Date: Fri, 21 May 2010 09:54:01 -0700
Message-Id: <1274460848-11377-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>

In this code section the final S of CONFIG_MODULES was missed making
the whole check useless

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
Cc: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 17e7d50..9630fbd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1420,7 +1420,7 @@ struct device *__root_device_register(const char *name, struct module *owner)
 		return ERR_PTR(err);
 	}
 
-#ifdef CONFIG_MODULE	/* gotta find a "cleaner" way to do this */
+#ifdef CONFIG_MODULES	/* gotta find a "cleaner" way to do this */
 	if (owner) {
 		struct module_kobject *mk = &owner->mkobj;
 
-- 
1.7.0.3

