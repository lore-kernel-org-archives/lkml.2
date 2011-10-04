Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab1JDTST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:18:19 -0400
Received: from claw.goop.org ([74.207.240.146]:56746 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539Ab1JDTSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:18:18 -0400
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
Subject: [PATCH RFC V3 4/8] x86/jump_label: drop arch_jump_label_text_poke_early()
Date: Tue,  4 Oct 2011 12:18:05 -0700
Message-Id: <b0ba511015ed44affa818415528bc00fd79d57bd.1317755691.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

It is no longer used.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/jump_label.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..2ad0298 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -42,10 +42,4 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
-{
-	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
-			JUMP_LABEL_NOP_SIZE);
-}
-
 #endif
-- 
1.7.6.4

