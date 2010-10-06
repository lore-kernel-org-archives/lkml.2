Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab0JFPuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:50:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32618 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab0JFPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:50:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6128"; a="56922404"
Date: Wed, 6 Oct 2010 08:50:48 -0700
From: David Brown <davidb@codeaurora.org>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>
Subject: Re: [PATCH 03/20 v2] msm: initial irq definitions for MSM8X60
Message-ID: <20101006155048.GA25662@huya.qualcomm.com>
References: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
 <1286350979-19328-4-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286350979-19328-4-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 12:42:42AM -0700, Jeff Ohlstein wrote:
> --- /dev/null
> +++ b/arch/arm/mach-msm/include/mach/irqs-8x60.h
> @@ -0,0 +1,43 @@
> +/* Copyright (c) 2010 Code Aurora Forum. All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above copyright
> + *       notice, this list of conditions and the following disclaimer in the
> + *       documentation and/or other materials provided with the distribution.
> + *     * Neither the name of Code Aurora nor
> + *       the names of its contributors may be used to endorse or promote
> + *       products derived from this software without specific prior written
> + *       permission.

We missed another of these.  Please be sure to carefully check that
all of the files have the GPLv2 license text, not this license.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
