Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1C3SDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:03:40 -0400
Received: from sous-sol.org ([216.99.217.87]:34157 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752925Ab1C3SDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:03:39 -0400
Date: Wed, 30 Mar 2011 11:02:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Mike Travis <travis@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 4/4] Intel pci: Use coherent DMA mask when requested
Message-ID: <20110330180245.GR18712@sequoia.sous-sol.org>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
 <20110329233602.935998468@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329233602.935998468@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Travis (travis@sgi.com) wrote:
>     The __intel_map_single function is not honoring the passed in
>     DMA mask.  This results in not using the coherent DMA mask when
>     called from intel_alloc_coherent().
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Mike Habeck <habeck@sgi.com>

Hmm, looks like it has actually been broken since it was introduced
in bb9e6d65.

Acked-by: Chris Wright <chrisw@sous-sol.org>
