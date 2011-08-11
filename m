Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1HKUvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:51:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39733 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab1HKUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:51:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6435"; a="109738040"
Message-ID: <4E4440C7.70208@codeaurora.org>
Date: Thu, 11 Aug 2011 14:51:19 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100722 Eudora/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <201108111455.56319.arnd@arndb.de>
In-Reply-To: <201108111455.56319.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 06:55 AM, Arnd Bergmann wrote:
> On Thursday 11 August 2011, Kenneth Heitke wrote:
>> From: Sagar Dharia<sdharia@codeaurora.org>
>>
>> SLIMbus (Serial Low Power Interchip Media Bus) is a specification
>> developed by MIPI (Mobile Industry Processor Interface) alliance.
>
> Hi Kenneth and Sagar,
>
> On a very high level, I think the driver is in the right place here,
> and it's appropriate to have a new bus type along with similar
> existing bus_types like i2c. It's also good to see that you have
> a good documentation file for this bus.
>
> My main issue with the driver is the device registration method
> that now looks a bit aged. More about this below.
>

Arnd,

Thank you for taking the time to review the driver.  I appreciate your 
comments and will roll them in to the next revision of the driver.  I'll 
also try to follow up with any questions and concerns that you raised.

thanks,
Ken

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
