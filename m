Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1ILORI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:17:08 -0400
Received: from outbound3.exchangedefender.com ([65.99.255.234]:44723 "EHLO
	outbound3.exchangedefender.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab1ILORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:17:07 -0400
X-ExchangeDefender-MagicKey: 1317046610.36428@Nw85MJByZziMz7WSF8JBvw
Message-ID: <4E6E1446.8000009@kelvatek.com>
Date: Mon, 12 Sep 2011 16:16:38 +0200
From: Krzysztof Kanas <k.kanas@kelvatek.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel  2.6.27.15  oops in PPP
References: <4E6DCD36.6020104@kelvatek.com> <20110912113641.GA32603@kroah.com> <4E6DF7EC.8000206@kelvatek.com> <20110912124917.GA16428@kroah.com>
In-Reply-To: <20110912124917.GA16428@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2011 14:16:44.0634 (UTC) FILETIME=[99ADEBA0:01CC7156]
X-ExchangeDefender-Info: Please contact the ISP for more information
X-MailScanner-ID: p8CEGh0O007816
X-ExchangeDefender-VirusScan: Found to be clean
X-ExchangeDefender-From: k.kanas@kelvatek.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2011 02:49 PM, Greg KH wrote:
> On Mon, Sep 12, 2011 at 02:15:40PM +0200, Krzysztof Kanas wrote:
>> On 09/12/2011 01:36 PM, Greg KH wrote:
>>> On Mon, Sep 12, 2011 at 11:13:26AM +0200, Krzysztof Kanas wrote:
>>>> Hi I am tracing kernel oops in 2.6.27.15 on ARM(CONFIG_CPU_ARM926T=y).
>>>
>>> 2.6.27.15 is quite old, why that version?  If you are stuck on 2.6.27,
>>> please use a newer stable version of it as odds are this is already
>>> resolved in one of the 40+ releases after yours (current one is
>>> 2.6.27.57 I think.)
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>> Yes I am quite stuck with that version - I will try to get new
>> stable version and see If that goes well. Unfortunately I have to
>> make sure that all applications etc are still working with new
>> kernel.
>
> There should not be _ANY_ user application change for stable kernel
> updates like you would be doing from 2.6.27.15 to 2.6.27.57 as we only
> accept bug fixes for stable kernel updates.
>
> greg k-h
>

Thanks, unfortunately kernel.org is down,
do you know by chance any other git mirror that I could use to clone 
2.6.27.* repository so I could get patches from upstream ?


-- 
Best regards,
Krzysztof Kanas


--
Asylia ExchangeDefender Message Security: Click below to verify authenticity
http://www.exchangedefender.com/verify.asp?id=p8CEGh0O007816&from=k.kanas@kelvatek.com


