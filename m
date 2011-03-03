Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1CCElY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 23:41:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2643 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1CCElX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 23:41:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77699912"
Message-ID: <4D6F1BF2.5080908@codeaurora.org>
Date: Wed, 02 Mar 2011 20:41:22 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD 5/6] MAINTAINERS: Add pmic8921, pmic8xxx
 subdevices maintainers
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>	 <1299104001-5240-6-git-send-email-adharmap@codeaurora.org> <1299106213.4208.112.camel@Joe-Laptop>
In-Reply-To: <1299106213.4208.112.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2011-03-02 at 14:13 -0800, adharmap@codeaurora.org wrote:
>> diff --git a/MAINTAINERS b/MAINTAINERS
> 
> The patch subject is not quite correct.
> You're adding patterns, not maintainers.

Ok will fix it in the next patch series.

> Another option is a wildcard pattern match like:
> 
> F:	drivers/*/pm8???-*
> 
> instead of:
> 
> F:	drivers/gpio/pm8xxx-gpio.c
> F:	drivers/mfd/pm8921-core.c
> F:	drivers/mfd/pm8xxx-irq.c
> F:	drivers/mfd/pm8xxx-mpp.c

Will do, thanks for this wildcard pattern

--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
