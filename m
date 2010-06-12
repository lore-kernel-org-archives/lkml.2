Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0FLCeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:34:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18166 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0FLCeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:34:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6010"; a="44219426"
Message-ID: <4C12F218.9010808@codeaurora.org>
Date: Fri, 11 Jun 2010 19:34:00 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Gregory Bean <gbean@codeaurora.org>, akpm@linux-foundation.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>
Subject: Re: [PATCH 1/2] gpio: msm7200a: Add gpiolib support for MSM chips.
References: <1276286332-13515-1-git-send-email-gbean@codeaurora.org> <1276286332-13515-2-git-send-email-gbean@codeaurora.org> <20100612021252.GB31045@fluff.org.uk>
In-Reply-To: <20100612021252.GB31045@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> On Fri, Jun 11, 2010 at 12:58:51PM -0700, Gregory Bean wrote:

...snip...

>> +MODULE_DESCRIPTION("Driver for Qualcomm MSM 7200a-family SoC GPIOs");
>> +MODULE_LICENSE("GPLv2");
> 
> you left out a MODULE_ALIAS() for your platform device.
> you could also do with a MODULE_AUTHOUR() line as well

Also, the string is "GPL v2".  See include/linux/license.h.

>> diff --git a/include/linux/msm7200a-gpio.h b/include/linux/msm7200a-gpio.h
>> new file mode 100644
>> index 0000000..3f1ef38
>> --- /dev/null
>> +++ b/include/linux/msm7200a-gpio.h
>> @@ -0,0 +1,44 @@
>> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
>> + *
>> + * Redistribution and use in source and binary forms, with or without
>> + * modification, are permitted provided that the following conditions are
>> + * met:
>> + *     * Redistributions of source code must retain the above copyright
>> diff --git a/include/linux/msm7200a-gpio.h b/include/linux/msm7200a-gpio.h
>> new file mode 100644
>> index 0000000..3f1ef38
>> --- /dev/null
>> +++ b/include/linux/msm7200a-gpio.h
>> @@ -0,0 +1,44 @@
>> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
>> + *
>> + * Redistribution and use in source and binary forms, with or without
> ;5B> + * modification, are permitted provided that the following conditions are
>> + * met:
>> + *     * Redistributions of source code must retain the above copyright
>> + *       notice, this list of conditions and the following disclaimer.
>> + *     * Redistributions in binary form must reproduce the above
>> + *       copyright notice, this list of conditions and the following
>> + *       disclaimer in the documentation and/or other materials provided
>> + *       with the distribution.
>> + *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
>> + *       contributors may be used to endorse or promote products derived
>> + *       from this software without specific prior written permission.
>> + *
>> + * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
>> + * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
>> + * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
>> + * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
>> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
>> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
>> + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
>> + * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
>> + * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
>> + * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>> + *
>> + */
> 
> Is this really GPL compatible?

It's BSD-style, so yes.


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
