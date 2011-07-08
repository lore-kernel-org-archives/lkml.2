Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1GHRXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:23:50 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17914 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1GHRXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:23:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6401"; a="102444396"
Message-ID: <4E173D23.4040808@codeaurora.org>
Date: Fri, 08 Jul 2011 10:23:47 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: davidb@codeaurora.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Collins <collinsd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Joe Perches <joe@perches.com>, Daniel Walker <dwalker@fifo99.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Qualcomm PM8921 MFD 3/6] gpio: pm8xxx-gpio: Add pm8xxx gpio
 driver
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org> <1299104001-5240-4-git-send-email-adharmap@codeaurora.org> <20110708154413.GA10567@suse.de>
In-Reply-To: <20110708154413.GA10567@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2011 08:44 AM, Greg KH wrote:
> On Wed, Mar 02, 2011 at 02:13:18PM -0800, adharmap@codeaurora.org wrote:
>> From: Abhijeet Dharmapurikar<adharmap@codeaurora.org>
>>
>> Add support for GPIO on Qualcomm PM8xxx PMIC chips.
>>
>> Change-Id: I5c00baeedc6c40ed40065d15c83577051e6ac9c6
>
> What is this line for?

That commit text artifact is for our internal review tool (gerrit). I 
cleaned it up in the later revision of the patch series.
The latest can be found here

https://lkml.org/lkml/2011/4/5/427

Thanks for looking,
Abhijeet

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

