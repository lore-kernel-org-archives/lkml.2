Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1ATBQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:16:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1ATBQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:16:36 -0500
Date: Wed, 19 Jan 2011 20:16:10 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: Update x86 cache descriptors.
Message-ID: <20110120011609.GA15462@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update to latest definitions in http://www.intel.com/Assets/PDF/appnote/241618.pdf

[note, this update of the doc has removed some old values which we have listed.
 I think until we have clarification that they were never used in production,
 they should be left there]

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7283e98..e4638e4 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -66,6 +66,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x45, LVL_2,      MB(2) },	/* 4-way set assoc, 32 byte line size */
 	{ 0x46, LVL_3,      MB(4) },	/* 4-way set assoc, 64 byte line size */
 	{ 0x47, LVL_3,      MB(8) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x48, LVL_2,      MB(3) },	/* 12-way set assoc, 64 byte line size */
 	{ 0x49, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
 	{ 0x4a, LVL_3,      MB(6) },	/* 12-way set assoc, 64 byte line size */
 	{ 0x4b, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
@@ -87,6 +88,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x7c, LVL_2,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x7d, LVL_2,      MB(2) },	/* 8-way set assoc, 64 byte line size */
 	{ 0x7f, LVL_2,      512 },	/* 2-way set assoc, 64 byte line size */
+	{ 0x80, LVL_2,      512 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x82, LVL_2,      256 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x83, LVL_2,      512 },	/* 8-way set assoc, 32 byte line size */
 	{ 0x84, LVL_2,      MB(1) },	/* 8-way set assoc, 32 byte line size */
