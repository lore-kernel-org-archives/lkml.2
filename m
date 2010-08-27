Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0H0ETF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 00:19:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7968 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0H0ETD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 00:19:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52410568"
Message-ID: <4C773CB6.1070306@codeaurora.org>
Date: Thu, 26 Aug 2010 21:19:02 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org, markgross@thegnar.org,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: Add system bus performance parameter
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saravana Kannan wrote:
> Maintainers,
> 
> I'm adding this parameter since it would be useful to some of the drivers of
> devices present in the ARM MSM chipsets.  Without the PM QoS parameter, there
> appears to be no clean way (in my opinion) to get requests from multiple
> drivers to increase the system bus performance (which is possible in MSM
> chipsets).
> 
> Adding this parameter would also allow me to delete some code in the Android
> specific implementation of arch/arm/mach-msm/clock.c that's unnecessarily
> mach-msm specific and use the generic clkdev library that's available for the
> ARM architecture. This would in turn allow me to upstream (after further clean
> up) more code that's currently present only in the kernel used in Android.
> 
> Thanks,
> Saravana
> ---
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks like the --compose option in git doesn't send email to all the 
recipients of the patch sets.  Adding others who might have missed my 
cover letter.  Sorry about the mix up.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
