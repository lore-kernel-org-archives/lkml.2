Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1FHNF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:05:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47441 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab1FHNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:05:25 -0400
Date: Wed, 8 Jun 2011 07:05:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/iommu/ relocations
Message-ID: <20110608130522.GC29089@parisc-linux.org>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307522062-19273-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 11:34:18AM +0300, Ohad Ben-Cohen wrote:
> Create a dedicated iommu drivers folder, put the base iommu code there,
> and move the existing IOMMU API users as well (msm-iommu, amd_iommu and
> intel-iommu).
> 
> Putting all iommu drivers together will ease finding similarities
> between different platforms, with the intention of solving problems once,
> in a generic framework, which everyone can use.
> 
> OMAP's iommu will be moved too as soon as it's migrated.
> 
> For previous discussions on this, please see:
> https://lkml.org/lkml/2011/6/2/369
> 
> Ohad Ben-Cohen (4):
>   drivers: iommu: move to a dedicated folder
>   msm: iommu: move to drivers/iommu/
>   x86: amd_iommu: move to drivers/iommu/
>   x86: intel-iommu: move to drivers/iommu/

You've missed at least parisc, ia64, alpha, sparc, powerpc and sh which
have IOMMUs.  Not that they necessarily all need to be moved across in
one patchset, but saying "all iommu drivers" is clearly false.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
