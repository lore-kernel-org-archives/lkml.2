Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1FMS0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:26:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45940 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1FMS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:26:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6376"; a="97226877"
From: David Brown <davidb@codeaurora.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] msm: iommu: move to drivers/iommu/
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
	<1307742947-32118-3-git-send-email-ohad@wizery.com>
Date: Mon, 13 Jun 2011 11:26:14 -0700
In-Reply-To: <1307742947-32118-3-git-send-email-ohad@wizery.com> (Ohad
	Ben-Cohen's message of "Sat, 11 Jun 2011 00:55:45 +0300")
Message-ID: <8yaips9fv09.fsf@huya.qualcomm.com>
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

Acked-by: David Brown <davidb@codeaurora.org>

I believe that Stepan Moskovochenko has some extra tests for this code,
but given that none of the code itself changes, I wouldn't expect any
problems.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
