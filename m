Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1HBEip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:38:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:35044 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab1HBEiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:38:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,305,1309762800"; 
   d="scan'208";a="34097752"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org
Subject: Updated direct IO optimization patchkit v2
Date: Mon,  1 Aug 2011 21:38:02 -0700
Message-Id: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various micro optimizations of the block direct IO path.

This addresses all review comments and adds an additional prefetch
optimization that gives another about 0.3% in a large macro benchmark.
Overall the patchkit is worht about 2.2% in the same macro benchmark.

I also ported it to current mainline, resolving some conflicts with
hch's recent changes to direct-io.

-Andi

