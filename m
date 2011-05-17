Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1EQEme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 00:42:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13174 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1EQEmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 00:42:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6348"; a="91547098"
Message-ID: <4DD1FCB3.8040700@codeaurora.org>
Date: Tue, 17 May 2011 10:12:27 +0530
From: Mohan Pallaka <mpallaka@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.intradead.org,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] pwm: Add __weak attributed functions for pwm	operations
References: <1305290602-29859-1-git-send-email-mpallaka@codeaurora.org> <1305290602-29859-2-git-send-email-mpallaka@codeaurora.org> <20110515080031.GA12911@core.coreip.homeip.net> <20110515105850.GH30539@n2100.arm.linux.org.uk>
In-Reply-To: <20110515105850.GH30539@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 5/15/2011 4:28 PM, Russell King - ARM Linux wrote:
> On Sun, May 15, 2011 at 01:00:31AM -0700, Dmitry Torokhov wrote:
>> On Fri, May 13, 2011 at 06:13:21PM +0530, Mohan Pallaka wrote:
>>> For chip drivers that support both pwm and non-pwm modes
>>> would encounter compilation errors if the platform doesn't
>>> have support for pwm though the chip is programmed to work
>>> in non-pwm mode. Add __weak attributed pwm functions to avoid
>>> compilation issues in these scenarios.
>>>
>> Russell,
>>
>> You seem to have authored pwm.h, do you have any objections to this
>> change?
> This seems to be a recipe for an oops.  Have a look at how
> linux/regulator/consumer.h deals with this kind of problem, and notice
> that we have CONFIG_HAVE_PWM to indicate whether this interface is
> supported or not.
Thanks for the suggestion. I'll upload a new patch.

--Mohan.
