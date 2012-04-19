Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab2DSWAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:00:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47528 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab2DSWAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:00:12 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2 4/5] MIPS: Select BUILDTIME_EXTABLE_SORT
Date: Thu, 19 Apr 2012 14:59:58 -0700
Message-Id: <1334872799-14589-5-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com>
References: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We can sort the exeception table at build time for MIPS, so let's do
it.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3134457..0db1cde 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -29,6 +29,7 @@ config MIPS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
+	select BUILDTIME_EXTABLE_SORT
 
 menu "Machine selection"
 
-- 
1.7.2.3

