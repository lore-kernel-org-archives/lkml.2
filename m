Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2CTXqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:46:24 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40178 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2CTXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:46:23 -0400
X-Originating-IP: 217.70.178.129
X-Originating-IP: 131.252.167.152
Date: Tue, 20 Mar 2012 16:46:14 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix typo in MODULE_DEVICE_TABLE example:
 s/x86_cpu/x86cpu/
Message-ID: <20120320234612.GA6999@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/cpu/match.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 5502b28..3656537 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -23,7 +23,7 @@
  * %X86_MODEL_ANY, %X86_FEATURE_ANY or 0 (except for vendor)
  *
  * Arrays used to match for this should also be declared using
- * MODULE_DEVICE_TABLE(x86_cpu, ...)
+ * MODULE_DEVICE_TABLE(x86cpu, ...)
  *
  * This always matches against the boot cpu, assuming models and features are
  * consistent over all CPUs.
-- 
1.7.9.1

