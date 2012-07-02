Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2GBSnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:43:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:46485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab2GBSnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="165894271"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Updated and combined Sandy Bridge/Ivy Bridge perf patchkits
Date: Mon,  2 Jul 2012 11:43:13 -0700
Message-Id: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I combined the SandyBridge and Ivy Bridge patchkit into one series,
because they always conflicted.

All review comments addressed I believe.

- Microcode load patches now rely on the patches to update microcode
on all CPUs.
- Updated version of the SandyBridge PEBS version check, to reenable
PEBS for systems with appropiate microcode
- Remove unsupported events on IvyBridge
- Add Precise Instruction Distribution for IvyBridge, to allow profiling
with less surprises and avoid some systematic errors
- Minor fixes

Please apply.

-Andi

