Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1FHW1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:27:15 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61409 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab1FHW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:27:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6371"; a="96489260"
From: David Brown <davidb@codeaurora.org>
To: Ohad Ben-Cohen <ohad@wizery.com>, stepanm@codeaurora.org
Cc: Joerg Roedel <Joerg.Roedel@amd.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/4] msm: iommu: move to drivers/iommu/
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
	<1307522062-19273-3-git-send-email-ohad@wizery.com>
Date: Wed, 08 Jun 2011 15:27:10 -0700
In-Reply-To: <1307522062-19273-3-git-send-email-ohad@wizery.com> (Ohad
	Ben-Cohen's message of "Wed, 8 Jun 2011 11:34:20 +0300")
Message-ID: <8yamxhsklhd.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08 2011, Ohad Ben-Cohen wrote:

> This should ease finding similarities with different platforms,
> with the intention of solving problems once in a generic framework
> which everyone can use.
>
> Compile-tested for MSM8X60.
>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  arch/arm/mach-msm/Kconfig                          |   12 ------------
>  arch/arm/mach-msm/Makefile                         |    2 +-
>  drivers/iommu/Kconfig                              |   11 +++++++++++
>  drivers/iommu/Makefile                             |    1 +
>  .../mach-msm/iommu.c => drivers/iommu/msm-iommu.c  |    0
>  5 files changed, 13 insertions(+), 13 deletions(-)
>  rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm-iommu.c (100%)

Moving the driver is good.  I'm wondering what we should do with
iommu_dev.c, though.  Wouldn't it make sense to move this file as well?

I've added the author, Stepan Moskovchenko, in case he has any feedback.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
