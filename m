Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1KUFbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 00:31:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14212 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1KUFbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 00:31:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 20 Nov 2011 21:31:05 -0800
Date: Mon, 21 Nov 2011 07:31:01 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Joerg Roedel <joro@8bytes.org>
CC: KyongHo Cho <pullip.cho@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 0/3] ARM: iommu: tegra: Add initial Tegra IOMMU driver
Message-ID: <20111121073101.6b369421.hdoyu@nvidia.com>
In-Reply-To: <20111118104354.GA19737@8bytes.org>
References: <1321527667-12923-1-git-send-email-hdoyu@nvidia.com>
	<CAHQjnOM-N9suPrv_nSRQsxGCNrf77rFLNtRcOdsjyz_O6bGdpA@mail.gmail.com>
	<20111118104354.GA19737@8bytes.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Fri, 18 Nov 2011 11:43:54 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> On Fri, Nov 18, 2011 at 07:19:53PM +0900, KyongHo Cho wrote:
> 
> > I found that those patches are not IOMMU API implementations.
> > I wonder why they need to be located in drivers/iommu?
> 
> The current effort goes into creating a generic framework for IOMMUs.
> These patches create their own framework which is totally the wrong
> direction, they even implement their own version of an IOMMU-API.
> 
> I object against merging them until they are converted to the generic
> IOMMU-API.

Ok, I'll in v2 of this patchset.
That was a plan, mentioned in the cover letter of this patchset.
