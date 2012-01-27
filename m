Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2A0AGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:06:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25680 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2A0AGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:06:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6601"; a="155939275"
Date: Thu, 26 Jan 2012 16:06:30 -0800
From: David Brown <davidb@codeaurora.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH] iommu/msm: Fix error handling in msm_iommu_unmap()
Message-ID: <20120127000630.GB16263@codeaurora.org>
References: <1327598984-20662-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327598984-20662-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 06:29:44PM +0100, Joerg Roedel wrote:
> Error handling in msm_iommu_unmap() is broken. On some error
> conditions retval is set to a non-zero value which causes
> the function to return 'len' at the end. This hides the
> error from the user. Zero should be returned in those error
> cases.
> 
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/msm_iommu.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
