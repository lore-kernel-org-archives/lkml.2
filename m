Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1LGRAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:00:30 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31552 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab1LGRA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:00:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6552"; a="142242775"
Date: Wed, 7 Dec 2011 09:00:24 -0800
From: David Brown <davidb@codeaurora.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/msm: Fix compile error in mach-msm/devices-iommu.c
Message-ID: <20111207170024.GA23621@huya.qualcomm.com>
References: <20111206102527.GI25178@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206102527.GI25178@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:25:27AM +0100, Joerg Roedel wrote:

> I just added a patch to my iommu/fixes branch to fix a compile error
> with IOMMU enabled. If there is another fix for this already somewhere
> please let me know the commit-id so that I can add it to my out-of-tree
> branch. If there is no other fix yet I will push this upstream soon with
> the next round of iommu-fixes.

You can go ahead and push this fix through your tree.  I'll enable the
iommu in my defconfigs so that I start catching things like this as
well.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
