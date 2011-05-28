Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1E1SPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:15:08 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33844 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754487Ab1E1SPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:15:05 -0400
Message-Id: <20110528181501.896092225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 28 May 2011 13:15:01 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Derek Fults <dfults@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Intel pci: Fix various problems with Intel IOMMU code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Various problems exist in the Intel IOMMU PCI driver when
	using DMA remapping in 1:1 identity mode on UV systems and
	devices cannot address all of physical memory.

	This patchset addresses those problems.

-- 
