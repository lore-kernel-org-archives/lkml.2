Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0CQQEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:04:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:33502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab0CQQEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:04:23 -0400
Date: Wed, 17 Mar 2010 16:03:42 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100317154038.GA29346@sgi.com>
References: <20100317154038.GA29346@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Delete unneeded boot messages
Message-ID: <tip-2acebe9ecb2b77876e87a1480729cfb2db4570dd@git.kernel.org>
Git-Commit-ID: 2acebe9ecb2b77876e87a1480729cfb2db4570dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 16:03:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2acebe9ecb2b77876e87a1480729cfb2db4570dd
Gitweb:     http://git.kernel.org/tip/2acebe9ecb2b77876e87a1480729cfb2db4570dd
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Wed, 17 Mar 2010 10:40:38 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 17:00:55 +0100

x86, UV: Delete unneeded boot messages

SGI:UV: Delete extra boot messages that describe the system
topology. These messages are no longer useful.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100317154038.GA29346@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 3740c8a..9a93b07 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -736,9 +736,6 @@ void __init uv_system_init(void)
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
-
-		printk(KERN_DEBUG "UV: cpu %d, apicid 0x%x, pnode %d, nid %d, lcpu %d, blade %d\n",
-			cpu, apicid, pnode, nid, lcpu, blade);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */
