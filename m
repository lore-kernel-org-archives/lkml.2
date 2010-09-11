Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0IKIes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 04:34:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:39265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab0IKIeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 04:34:44 -0400
Date: Sat, 11 Sep 2010 08:34:23 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4C8B2AFA.2000705@kernel.org>
References: <4C8B2AFA.2000705@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] powerpc, memblock: Fix memblock API change fallout
Message-ID: <tip-823108a056c52a83c32ca199a57566a36fad4d19@git.kernel.org>
Git-Commit-ID: 823108a056c52a83c32ca199a57566a36fad4d19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 11 Sep 2010 08:34:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  823108a056c52a83c32ca199a57566a36fad4d19
Gitweb:     http://git.kernel.org/tip/823108a056c52a83c32ca199a57566a36fad4d19
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 11 Sep 2010 00:08:42 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Sep 2010 10:30:28 +0200

powerpc, memblock: Fix memblock API change fallout

Fix memblock API change fallout in the WII code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: linux-mm@kvack.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <4C8B2AFA.2000705@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/platforms/embedded6xx/wii.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index 8450c29..649473a 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -65,7 +65,7 @@ static int __init page_aligned(unsigned long x)
 
 void __init wii_memory_fixups(void)
 {
-	struct memblock_region *p = memblock.memory.region;
+	struct memblock_region *p = memblock.memory.regions;
 
 	/*
 	 * This is part of a workaround to allow the use of two
