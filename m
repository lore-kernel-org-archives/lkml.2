Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1GLFDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:03:23 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:26551 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1GLFDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:03:22 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, mingo@elte.hu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Message-Id: <20110712050244.2462.51826.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Subject: [PATCH 0/2] x86, ioapic: Consider IR when printing out IOAPIC related output
Date: Tue, 12 Jul 2011 05:03:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
These two patches should apply cleanly to your latest "linux-2.6-x86" tree.

Naga Chumbalkar (2):
  Print IR_IO_APIC_route_entry when IR is enabled
  Print IRTE when IR is enabled

 arch/x86/kernel/apic/io_apic.c |   85 +++++++++++++++++++++++++++++----------
 1 files changed, 63 insertions(+), 22 deletions(-)

