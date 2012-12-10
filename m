Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2LJJC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:02:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44429 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2LJJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:02:23 -0500
Message-ID: <50C5A50E.4070602@ti.com>
Date: Mon, 10 Dec 2012 14:32:06 +0530
From: Vaibhav Hiremath <hvaibhav@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Porter, Matt" <mporter@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dill, Russ" <russ.dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] da8xx: Allow use by am33xx based devices
References: <1351698968-3965-1-git-send-email-panto@antoniou-consulting.com> <A73F36158E33644199EB82C5EC81C7BC3EA1452B@DBDE01.ent.ti.com>
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3EA1452B@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/6/2012 1:38 PM, Manjunathappa, Prakash wrote:
> Hi Tomi,
> 
> On Wed, Oct 31, 2012 at 10:52:59, Manjunathappa, Prakash wrote:
>> Hi,
>>
>> On Wed, Oct 31, 2012 at 21:26:08, Pantelis Antoniou wrote:
>>> This driver can be used for AM33xx devices, like the popular beaglebone.
>>>
>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>>> ---
>>>  drivers/video/Kconfig | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
>>> index 9791d10..e7868d8 100644
>>> --- a/drivers/video/Kconfig
>>> +++ b/drivers/video/Kconfig
>>> @@ -2202,7 +2202,7 @@ config FB_SH7760
>>>  
>>>  config FB_DA8XX
>>>  	tristate "DA8xx/OMAP-L1xx Framebuffer support"
>>> -	depends on FB && ARCH_DAVINCI_DA8XX
>>> +	depends on FB && (ARCH_DAVINCI_DA8XX || SOC_AM33XX)
>>
>> Agreed this is present on da8xx and am33xx, but moving forward for
>> supporting DT, we should be avoiding these dependencies. So instead
>> change this to remove machine dependencies.
>>
> 
> I could be wrong here, having dependency on platform seems to be right.
> Otherwise may lead to build errors for other platforms. 

No, it should not result in to build error unless driver uses some
platform specific api's.

Thanks,
Vaibhav

> Please ignore my
> comments and accept this patch.
> 
> Thanks,
> Prakash
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 
