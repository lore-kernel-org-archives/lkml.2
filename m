Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1ILMPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:15:36 -0400
Received: from outbound3.exchangedefender.com ([65.99.255.234]:44279 "EHLO
	outbound3.exchangedefender.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400Ab1ILMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:15:35 -0400
X-ExchangeDefender-MagicKey: 1317039329.85658@lOxcDhdYLygr8R5gWlPq1g
Message-ID: <4E6DF7EC.8000206@kelvatek.com>
Date: Mon, 12 Sep 2011 14:15:40 +0200
From: Krzysztof Kanas <k.kanas@kelvatek.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel  2.6.27.15  oops in PPP
References: <4E6DCD36.6020104@kelvatek.com> <20110912113641.GA32603@kroah.com>
In-Reply-To: <20110912113641.GA32603@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2011 12:15:22.0607 (UTC) FILETIME=[A540C7F0:01CC7145]
X-ExchangeDefender-Info: Please contact the ISP for more information
X-MailScanner-ID: p8CCFMxY021138
X-ExchangeDefender-VirusScan: Found to be clean
X-ExchangeDefender-From: k.kanas@kelvatek.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2011 01:36 PM, Greg KH wrote:
> On Mon, Sep 12, 2011 at 11:13:26AM +0200, Krzysztof Kanas wrote:
>> Hi I am tracing kernel oops in 2.6.27.15 on ARM(CONFIG_CPU_ARM926T=y).
>
> 2.6.27.15 is quite old, why that version?  If you are stuck on 2.6.27,
> please use a newer stable version of it as odds are this is already
> resolved in one of the 40+ releases after yours (current one is
> 2.6.27.57 I think.)
>
> thanks,
>
> greg k-h
>
Yes I am quite stuck with that version - I will try to get new stable 
version and see If that goes well. Unfortunately I have to make sure 
that all applications etc are still working with new kernel.

To me it is only strange that started to show when I changed kernel config.

Anyway I will see if upgrade helps :)


-- 
Best regards,
Krzysztof Kanas



--
Asylia ExchangeDefender Message Security: Click below to verify authenticity
http://www.exchangedefender.com/verify.asp?id=p8CCFMxY021138&from=k.kanas@kelvatek.com


