Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1AXPF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:05:57 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:32898
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981Ab1AXPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:05:55 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LFJ8LL-02-KZE-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <andreas.herrmann3@amd.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 0/4] x86, amd: family 0x15 L3 cache features
Date: Mon, 24 Jan 2011 16:05:39 +0100
Message-ID: <1295881543-572552-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enables L3 cache index disable and adds support for L3
cache partitioning on AMD family 0x15 CPUs.

This stuff applies against tip/master 3ff6dcac735704824c1dff64dc6863c390d364cc.

Andreas Herrmann (1):
  x86, amd: Normalize compute unit IDs on multi-node processors

Hans Rosenfeld (3):
  x86, amd: Enable L3 cache index disable on family 0x15
  x86, amd: Extend AMD northbridge caching code to support "Link
    Control" devices
  x86, amd: Support L3 Cache Partitioning on AMD family 0x15 CPUs

 arch/x86/include/asm/amd_nb.h         |    4 ++
 arch/x86/kernel/amd_nb.c              |   69 ++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/amd.c             |    8 +++-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   73 +++++++++++++++++++++++++++-----
 arch/x86/kernel/smpboot.c             |    1 +
 include/linux/pci_ids.h               |    1 +
 6 files changed, 140 insertions(+), 16 deletions(-)


