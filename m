Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1JAV4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 17:56:05 -0400
Received: from claw.goop.org ([74.207.240.146]:49211 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1JAVzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 17:55:44 -0400
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
Subject: [PATCH RFC V2 4/5] x86/jump_label: drop arch_jump_label_text_poke_early()
Date: Sat,  1 Oct 2011 14:55:36 -0700
Message-Id: <48b39edbbd82711557c52a584c776e1cb44fe869.1317506051.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
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
1.7.6.2

