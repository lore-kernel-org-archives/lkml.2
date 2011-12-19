Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1LSPSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:18:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58264 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751378Ab1LSPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:18:16 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18LB5sMjWkLE56e5tZV1FTj5fjUjrV5mYsV2Vm6ZY
	JQD+lHWPa8pA8s
Message-ID: <4EEF55AC.6060107@gmx.de>
Date: Mon, 19 Dec 2011 15:18:04 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Marek Vasut <marek.vasut@gmail.com>, linux-kernel@vger.kernel.org,
        Wolfgang Denk <wd@denx.de>, Stefano Babic <sbabic@denx.de>,
        Huang Shijie <b32955@freescale.com>, Axel Lin <axel.lin@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] MXSFB: Fix driver registration
References: <1324169888-6687-1-git-send-email-marek.vasut@gmail.com> <CAAQ0ZWSJ0Yzr2Gk9MBQ0nvVCWxr0yWF_RFTy3isqc0pgEDdRxw@mail.gmail.com>
In-Reply-To: <CAAQ0ZWSJ0Yzr2Gk9MBQ0nvVCWxr0yWF_RFTy3isqc0pgEDdRxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

can you please resend the patch to me and the fbdev mailing list, preferably
with all Ack's you received until now included.

On 12/19/2011 01:51 PM, Shawn Guo wrote:
> Cc-ed Florian and linux-fbdev@vger.kernel.org, as I guess Florian is
> the person who will take this patch.

Thanks, I will. I guess you wanted to Ack this patch?


Thanks,

Florian Tobias Schandinat

> 
> -- Regards,Shawn
> On 18 December 2011 08:58, Marek Vasut <marek.vasut@gmail.com> wrote:
>> The driver should be registered with mxsfb_driver, not with mxsfb_devtype.
>> This caused obvious null pointer dereference and crash.
>>
>> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
>> Cc: Wolfgang Denk <wd@denx.de>
>> Cc: Stefano Babic <sbabic@denx.de>
>> Cc: Shawn Guo <shawn.guo@linaro.org>
>> Cc: Huang Shijie <b32955@freescale.com>
>> Cc: Axel Lin <axel.lin@gmail.com>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> ---
>>  drivers/video/mxsfb.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
>> index 18742c2..d29c7c0 100644
>> --- a/drivers/video/mxsfb.c
>> +++ b/drivers/video/mxsfb.c
>> @@ -902,7 +902,7 @@ static struct platform_driver mxsfb_driver = {
>>        },
>>  };
>>
>> -module_platform_driver(mxsfb_devtype);
>> +module_platform_driver(mxsfb_driver);
>>
>>  MODULE_DESCRIPTION("Freescale mxs framebuffer driver");
>>  MODULE_AUTHOR("Sascha Hauer, Pengutronix");
>> --
>> 1.7.6.4
>>
> 

