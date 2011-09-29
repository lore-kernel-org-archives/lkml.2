Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab1I2X1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:27:53 -0400
Received: from claw.goop.org ([74.207.240.146]:43206 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab1I2X0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:26:54 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 8/8] jump_label: drop default arch_jump_label_transform_early
Date: Thu, 29 Sep 2011 16:26:38 -0700
Message-Id: <26bdb3886266f38a3e1664568a0a0193eb882aab.1317338254.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 kernel/jump_label.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 54e8e2d..3010bcf 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -121,15 +121,6 @@ static void __jump_label_update(struct jump_label_key *key,
 	}
 }
 
-/*
- * Not all archs need this.
- */
-void __weak arch_jump_label_transform_early(struct jump_entry *entry,
-					    enum jump_label_type type)
-{
-	arch_jump_label_transform(entry, type);	
-}
-
 static __init int jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
-- 
1.7.6.2

