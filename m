Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab1FQSIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:08:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54579 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab1FQSIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:08:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6380"; a="98410119"
From: David Brown <davidb@codeaurora.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] msm: iommu: move to drivers/iommu/
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
	<1307742947-32118-3-git-send-email-ohad@wizery.com>
Date: Fri, 17 Jun 2011 11:08:40 -0700
In-Reply-To: <1307742947-32118-3-git-send-email-ohad@wizery.com> (Ohad
	Ben-Cohen's message of "Sat, 11 Jun 2011 00:55:45 +0300")
Message-ID: <8yatyboqqjb.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10 2011, Ohad Ben-Cohen wrote:

> This should ease finding similarities with different platforms,
> with the intention of solving problems once in a generic framework
> which everyone can use.
>
> Compile-tested for MSM8X60.
>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
