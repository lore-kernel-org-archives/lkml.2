Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2BWAte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:49:34 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35938 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab2BWAtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:49:33 -0500
Message-Id: <20120223004930.817124691@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Feb 2012 18:49:30 -0600
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>, Daniel Rahn <drahn@suse.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Updates for SGI UV1/UV2 systems...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Fix arbitrary limitation of number of IOMMU (from 64 to MAX_IO_APICS [128])

- Fix IOMMU identity mapping to not map a PCI device that does not to DMA.

-- 
