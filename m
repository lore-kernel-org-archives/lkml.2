Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab2FOSNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:13:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65479 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2FOSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:13:39 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Subject: A couple of minor irqdomain fixes
Date: Fri, 15 Jun 2012 12:13:29 -0600
Message-Id: <1339784011-7604-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple of irqdomain changes that I'm pushing out to
irqdomain/next right away.  The first give irqdomain some NUMA
awareness when allocating irqdescs, and the second is simply dead code
removal.

Grant Likely (1):
      irqdomain: Remove unnecessary test for IRQ_DOMAIN_MAP_LEGACY

Paul Mundt (1):
      irqdomain: Simple NUMA awareness.

 include/linux/of.h     |   15 ++++++++++-----
 kernel/irq/irqdomain.c |   16 +++++++++-------
 2 files changed, 19 insertions(+), 12 deletions(-)
