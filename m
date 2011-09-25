Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928Ab1IYFDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 01:03:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65000 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1IYFDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 01:03:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6479"; a="121219541"
Date: Sat, 24 Sep 2011 22:03:08 -0700
From: David Brown <davidb@codeaurora.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH v3 3/6] iommu/msm: announce supported page sizes
Message-ID: <20110925050308.GA6493@huya.qualcomm.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-4-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316195506-9777-4-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 08:51:43PM +0300, Ohad Ben-Cohen wrote:
> Let the IOMMU core know we support 4KiB, 64KiB, 1MiB and 16MiB page sizes.
> 
> This way the IOMMU core can split any arbitrary-sized physically
> contiguous regions (that it needs to map) as needed.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
>  drivers/iommu/msm_iommu.c |    8 +++++++-

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
