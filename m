Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab0LJA6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:58:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64321 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab0LJA6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 19:58:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6192"; a="66018434"
Message-ID: <4D017B45.4000805@codeaurora.org>
Date: Thu, 09 Dec 2010 16:58:45 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Nicolas Pitre <nico@marvell.com>, linux-kernel@vger.kernel.org,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to	early_initcall
References: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org> <20101202221909.GK29347@n2100.arm.linux.org.uk> <4CF94DDD.8000409@codeaurora.org> <20101203203653.GB10245@n2100.arm.linux.org.uk> <4CFDD297.4020600@codeaurora.org> <15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org> <20101209103835.GA31465@n2100.arm.linux.org.uk>
In-Reply-To: <20101209103835.GA31465@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Thu, Dec 09, 2010 at 01:23:24AM -0800, skannan@codeaurora.org wrote:
>> Russell, Have you had a chance to look at this? Any comments? How do we
>> move ahead?
> 
> I had connected the other thread with this one - it's pretty hard not
> to as it included this patch in that set as the first patch.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ok. So what's your take on handling the cache coherency with secure 
domain? Do we get to add cache invalidate APIs outside of DMA APIs?

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
