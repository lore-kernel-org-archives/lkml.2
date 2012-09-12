Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab2ILNup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:50:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2ILNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:50:42 -0400
Date: Wed, 12 Sep 2012 06:50:20 -0700
From: tip-bot for Attilio Rao <attilio.rao@citrix.com>
Message-ID: <tip-64282278989d5b0398dcb3ba7904cb00c621dc35@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, tglx@linutronix.de, attilio.rao@citrix.com,
        xen-devel@lists.xensource.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, tglx@linutronix.de, attilio.rao@citrix.com,
        xen-devel@lists.xensource.com
In-Reply-To: <1345580561-8506-6-git-send-email-attilio.rao@citrix.com>
References: <1345580561-8506-6-git-send-email-attilio.rao@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Document x86_init.paging.pagetable_init()
Git-Commit-ID: 64282278989d5b0398dcb3ba7904cb00c621dc35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 12 Sep 2012 06:50:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64282278989d5b0398dcb3ba7904cb00c621dc35
Gitweb:     http://git.kernel.org/tip/64282278989d5b0398dcb3ba7904cb00c621dc35
Author:     Attilio Rao <attilio.rao@citrix.com>
AuthorDate: Tue, 21 Aug 2012 21:22:41 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Sep 2012 15:33:07 +0200

x86: Document x86_init.paging.pagetable_init()

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
Acked-by: <konrad.wilk@oracle.com>
Cc: <Ian.Campbell@citrix.com>
Cc: <Stefano.Stabellini@eu.citrix.com>
Cc: <xen-devel@lists.xensource.com>
Link: http://lkml.kernel.org/r/1345580561-8506-6-git-send-email-attilio.rao@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/x86_init.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 995ea5c..5769349 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -81,7 +81,10 @@ struct x86_init_mapping {
 
 /**
  * struct x86_init_paging - platform specific paging functions
- * @pagetable_init:		platform specific paging initialization call
+ * @pagetable_init:	platform specific paging initialization call to setup
+ *			the kernel pagetables and prepare accessors functions.
+ *			Callback must call paging_init(). Called once after the
+ *			direct mapping for phys memory is available.
  */
 struct x86_init_paging {
 	void (*pagetable_init)(void);
