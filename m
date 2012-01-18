Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2ARRLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:11:00 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58602 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214Ab2ARRK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:10:59 -0500
Date: Wed, 18 Jan 2012 11:10:57 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: [PATCH] x86 uv: define uv_irq_lock
Message-ID: <20120118171057.GB10185@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly define/initialize the uv_irq_lock.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/platform/uv/uv_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/platform/uv/uv_irq.c
===================================================================
--- linux.orig/arch/x86/platform/uv/uv_irq.c
+++ linux/arch/x86/platform/uv/uv_irq.c
@@ -25,7 +25,7 @@ struct uv_irq_2_mmr_pnode{
 	int			irq;
 };
 
-static spinlock_t		uv_irq_lock;
+static DEFINE_SPINLOCK(uv_irq_lock);
 static struct rb_root		uv_irq_root;
 
 static int uv_set_irq_affinity(struct irq_data *, const struct cpumask *, bool);
