Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab0EFRjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab0EFRi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:38:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/13] x86: removing redundant ifdef
Date: Thu,  6 May 2010 19:36:08 +0200
Message-Id: <1273167377-14270-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/early-quirks.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index ebdb85c..76b8cd9 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -97,7 +97,6 @@ static void __init nvidia_bugs(int num, int slot, int func)
 }
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
-#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -115,7 +114,6 @@ static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 	d &= 0xff;
 	return d;
 }
-#endif
 
 static void __init ati_bugs(int num, int slot, int func)
 {
-- 
1.6.6.1

