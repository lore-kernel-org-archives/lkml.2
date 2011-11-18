Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1KRKoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:44:01 -0500
Received: from 8bytes.org ([88.198.83.132]:56845 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab1KRKoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:44:00 -0500
Date: Fri, 18 Nov 2011 11:43:54 +0100
From: Joerg Roedel <joro@8bytes.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: hdoyu@nvidia.com, linux-tegra@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] ARM: iommu: tegra: Add initial Tegra IOMMU driver
Message-ID: <20111118104354.GA19737@8bytes.org>
References: <1321527667-12923-1-git-send-email-hdoyu@nvidia.com> <CAHQjnOM-N9suPrv_nSRQsxGCNrf77rFLNtRcOdsjyz_O6bGdpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQjnOM-N9suPrv_nSRQsxGCNrf77rFLNtRcOdsjyz_O6bGdpA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 07:19:53PM +0900, KyongHo Cho wrote:

> I found that those patches are not IOMMU API implementations.
> I wonder why they need to be located in drivers/iommu?

The current effort goes into creating a generic framework for IOMMUs.
These patches create their own framework which is totally the wrong
direction, they even implement their own version of an IOMMU-API.

I object against merging them until they are converted to the generic
IOMMU-API.


        Joerg

