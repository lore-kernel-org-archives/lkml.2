Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2ESGMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:12:08 -0400
Received: from linux-sh.org ([111.68.239.195]:60858 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab2ESGMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:12:05 -0400
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] irqdomain cleanups + identity mapping support
Date: Sat, 19 May 2012 15:11:40 +0900
Message-Id: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
X-Mailer: git-send-email 1.7.10.207.g0bb2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the current patch stack I've got against the irqdomain code, which
is about what I need to start being able to reasonably start converting
the SH INTC subsystem over to it.

This whole series is also available via git at:

	git://github.com/pmundt/linux-sh.git common/irqdomain

but I've not yet created a signed tag to pull from as there's likely
still a fair bit of work to do. The diffstat looks innocuous enough, but
is obviously of no real value in this case:

Paul Mundt (8):
      irqdomain: Support removal of IRQ domains.
      irqdomain: Export remaining public API symbols.
      irqdomain: Make irq_domain_simple_map() static.
      irqdomain: Simple NUMA awareness.
      irqdomain: Kill off duplicate definitions.
      irqdomain: Support identity mapped VIRQ allocation.
      irqdomain: trivial pr_fmt conversion.
      irqdomain: Support insertion of existing IRQ allocations.

 include/linux/irqdomain.h |   12 +-
 include/linux/of.h        |   10 +-
 kernel/irq/irqdomain.c    |  187 ++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 168 insertions(+), 41 deletions(-)

