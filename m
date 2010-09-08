Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab0IHIgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:36:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:55745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab0IHIgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:36:48 -0400
Date: Wed, 8 Sep 2010 08:35:47 GMT
From: tip-bot for Christian Dietrich 
	<qy03fugy@stud.informatik.uni-erlangen.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        qy03fugy@stud.informatik.uni-erlangen.de, tglx@linutronix.de,
        mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, qy03fugy@stud.informatik.uni-erlangen.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <d4376e6d79b8dc0f89a4b3ce4a880904a7b93ead.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <d4376e6d79b8dc0f89a4b3ce4a880904a7b93ead.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Remove unnecessary #ifdef ACPI/X86_IO_ACPI
Message-ID: <tip-0f1cf415f00286a38f5ce35b459342dbfc895b50@git.kernel.org>
Git-Commit-ID: 0f1cf415f00286a38f5ce35b459342dbfc895b50
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:35:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f1cf415f00286a38f5ce35b459342dbfc895b50
Gitweb:     http://git.kernel.org/tip/0f1cf415f00286a38f5ce35b459342dbfc895b50
Author:     Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
AuthorDate: Mon, 6 Sep 2010 16:36:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Sep 2010 08:14:02 +0200

x86: Remove unnecessary #ifdef ACPI/X86_IO_ACPI

The ACPI/X86_IO_ACPI ifdef isn't necessary at this point,
because it is checked in an outer ifdef level already and has no
effect here.

Cleanup only, no functional effect.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: vamos-dev@i4.informatik.uni-erlangen.de
LKML-Reference: <d4376e6d79b8dc0f89a4b3ce4a880904a7b93ead.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/early-quirks.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index e5cc7e8..e4bd78c 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -98,7 +98,6 @@ static void __init nvidia_bugs(int num, int slot, int func)
 }
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
-#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -116,7 +115,6 @@ static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 	d &= 0xff;
 	return d;
 }
-#endif
 
 static void __init ati_bugs(int num, int slot, int func)
 {
