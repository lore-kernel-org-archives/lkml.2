Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1H2IhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:37:03 -0400
Received: from 8bytes.org ([88.198.83.132]:56398 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1H2Ig6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:36:58 -0400
Date: Mon, 29 Aug 2011 10:36:57 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: linux-next: build failure after merge of the iommu tree
Message-ID: <20110829083656.GH8978@8bytes.org>
References: <20110829133237.80467b5d54438ace53b324df@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829133237.80467b5d54438ace53b324df@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 01:32:37PM +1000, Stephen Rothwell wrote:
> After merging the iommu tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/iommu/omap-iommu.c:27:24: fatal error: plat/iommu.h: No such file or directory
> 
> Caused by commit fcf3a6ef4a58 ("omap: iommu/iovmm: move to dedicated
> iommu folder").  Presumably building of this code should be restricted to
> just some platforms only.
> 
> I have dropped the iommu tree for today (since I have no older working
> version).

Thanks for the report Stephen, I apply Ohads patch today so that this
should be fixed for tomorrow.

	Joerg

