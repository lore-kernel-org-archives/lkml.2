Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1DAC6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 22:58:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:46359 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab1DAC6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 22:58:15 -0400
Date: Fri, 1 Apr 2011 11:57:07 +0900
To: chrisw@sous-sol.org
Cc: travis@sgi.com, dwmw2@infradead.org, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        habeck@sgi.com, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 4/4] Intel pci: Use coherent DMA mask when requested
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110330180245.GR18712@sequoia.sous-sol.org>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
	<20110329233602.935998468@gulag1.americas.sgi.com>
	<20110330180245.GR18712@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110401115425Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 01 Apr 2011 11:57:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 11:02:45 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> * Mike Travis (travis@sgi.com) wrote:
> >     The __intel_map_single function is not honoring the passed in
> >     DMA mask.  This results in not using the coherent DMA mask when
> >     called from intel_alloc_coherent().
> > 
> > Signed-off-by: Mike Travis <travis@sgi.com>
> > Reviewed-by: Mike Habeck <habeck@sgi.com>
> 
> Hmm, looks like it has actually been broken since it was introduced
> in bb9e6d65.

Oops, you are right.

The patch looks good to me.

Thanks,
