Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1DKENJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 00:13:09 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41161 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1DKENC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 00:13:02 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linutronix.de, bigeasy@linutronix.de
Subject: [PATCHES v3] pci/of: Generic PCI <-> OF matching
Date: Mon, 11 Apr 2011 14:12:44 +1000
Message-Id: <1302495170-973-1-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a new batch. This time, I'm reasonably confident I build-tested the
right commit-id's on sparc :-)

To sort out the sparc problem I took a slightly different approach than
discussed. I made the new code be of_pci.c (which I enabled on sparc)
and put the old stuff into of_pci_irq.c (which should still be disabled
there).

I've also consolidated pci_bus_to_OF_node() while at it.

