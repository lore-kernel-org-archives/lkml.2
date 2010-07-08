Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0GHHSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:18:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:51571 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0GHHSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:18:03 -0400
Date: Thu, 8 Jul 2010 07:17:33 GMT
From: tip-bot for Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, rakib.mullick@gmail.com, martinez.javier@gmail.com,
       ebiederm@xmission.com, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rakib.mullick@gmail.com, gorcunov@openvz.org, martinez.javier@gmail.com,
       ebiederm@xmission.com, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1278546719.9020.4.camel@lenovo>
References: <1278546719.9020.4.camel@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic/es7000_32: Remove unused variable
Message-ID: <tip-5bbd4a336c81d32df71642abf310cf3d0c98dc9b@git.kernel.org>
Git-Commit-ID: 5bbd4a336c81d32df71642abf310cf3d0c98dc9b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Jul 2010 07:17:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bbd4a336c81d32df71642abf310cf3d0c98dc9b
Gitweb:     http://git.kernel.org/tip/5bbd4a336c81d32df71642abf310cf3d0c98dc9b
Author:     Javier Martinez Canillas <martinez.javier@gmail.com>
AuthorDate: Wed, 7 Jul 2010 19:51:59 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Jul 2010 09:14:37 +0200

x86/apic/es7000_32: Remove unused variable

In today's linux-next I got this compile warning:

 arch/x86/kernel/apic/es7000_32.c:132: warning: 'base' defined but not used

Current patch solves the issue removing the unused variable.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <1278546719.9020.4.camel@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/es7000_32.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 425e53a..8593582 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -129,7 +129,6 @@ int					es7000_plat;
  * GSI override for ES7000 platforms.
  */
 
-static unsigned int			base;
 
 static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
