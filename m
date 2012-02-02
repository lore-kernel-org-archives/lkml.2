Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2BBX5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:57:05 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58797 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab2BBX4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:56:52 -0500
Message-Id: <20120202235650.563029146@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Feb 2012 17:56:50 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Updates for SGI UV1/UV2 systems...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Fix arbitrary limitation of number of IOMMU (from 64 to MAX_IO_APICS [128])

- Fix IOMMU identity mapping to not map a PCI device that does not to DMA.

- Update uv_handle_nmi to latest NMI processing.

-- 
