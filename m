Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab0LHAsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:11 -0500
Received: from kroah.org ([198.145.64.141]:58612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab0LHAsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:03 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:34 2010
Message-Id: <20101208004434.431857431@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>,
        maximilian attems <max@stro.at>
Subject: [101/127] x86, UV: Delete unneeded boot messages
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jack Steiner <steiner@sgi.com>

commit 2acebe9ecb2b77876e87a1480729cfb2db4570dd upstream.

SGI:UV: Delete extra boot messages that describe the system
topology. These messages are no longer useful.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100317154038.GA29346@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -636,9 +636,6 @@ void __init uv_system_init(void)
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 		max_pnode = max(pnode, max_pnode);
-
-		printk(KERN_DEBUG "UV: cpu %d, apicid 0x%x, pnode %d, nid %d, lcpu %d, blade %d\n",
-			cpu, apicid, pnode, nid, lcpu, blade);
 	}
 
 	/* Add blade/pnode info for nodes without cpus */


