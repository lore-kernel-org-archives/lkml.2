Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1HDQSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:18:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38401 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1HDQRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:17:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6427"; a="107926366"
Date: Thu, 4 Aug 2011 09:17:52 -0700
From: David Brown <davidb@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: David Miller <davem@davemloft.net>, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/address: Add of_iomap_nocache
Message-ID: <20110804161752.GA19156@huya.qualcomm.com>
References: <1312451629-28036-1-git-send-email-davidb@codeaurora.org>
 <20110804.031254.836213129500890372.davem@davemloft.net>
 <4E3AC05A.1070208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3AC05A.1070208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 10:52:58AM -0500, Rob Herring wrote:
> On 08/04/2011 05:12 AM, David Miller wrote:
> > From: David Brown <davidb@codeaurora.org>
> > Date: Thu,  4 Aug 2011 02:53:49 -0700
> > 
> >> Add uncached mappings from devicetree nodes similar to regular io
> >> mappings.
> >>
> >> Signed-off-by: David Brown <davidb@codeaurora.org>
> > 
> > You'll need to add a sparc implementation.
> 
> Sparc just defines ioremap_nocache to ioremap, so is that really needed?

The first version of my patch only defines the new function in a file
compiled on non-SPARC targets.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
