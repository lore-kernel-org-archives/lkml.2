Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1INIQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:16:50 -0400
Received: from outbound3.exchangedefender.com ([65.99.255.234]:54090 "EHLO
	outbound3.exchangedefender.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181Ab1INIQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:16:48 -0400
X-ExchangeDefender-MagicKey: 1317197798.3367@xq4tPl+2GXRCUzK3VZUA7A
Message-ID: <4E7062F2.1020004@kelvatek.com>
Date: Wed, 14 Sep 2011 10:16:50 +0200
From: Krzysztof Kanas <k.kanas@kelvatek.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel  2.6.27.15  oops in PPP
References: <4E6DCD36.6020104@kelvatek.com> <20110912113641.GA32603@kroah.com> <4E6DF7EC.8000206@kelvatek.com> <20110912124917.GA16428@kroah.com> <4E6E1446.8000009@kelvatek.com> <20110912142641.GA17687@kroah.com>
In-Reply-To: <20110912142641.GA17687@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2011 08:16:29.0629 (UTC) FILETIME=[9AF566D0:01CC72B6]
X-ExchangeDefender-Info: Please contact the ISP for more information
X-MailScanner-ID: p8E8GTfa017441
X-ExchangeDefender-VirusScan: Found to be clean
X-ExchangeDefender-From: k.kanas@kelvatek.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2011 04:26 PM, Greg KH wrote:
>>>>> 2.6.27.15 is quite old, why that version?  If you are stuck on 2.6.27,
>>>>> please use a newer stable version of it as odds are this is already
>>>>> resolved in one of the 40+ releases after yours (current one is
>>>>> 2.6.27.57 I think.)
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>

I upgraded kernel to 2.6.27.57 the bug is still occurring when I kill 
pppd in user space, I can post oops it if that helps.

But I made some test with  2.6.39 and it didn't crashed. So I will hunt 
in between for patch that fixes the issue - don't have better idea.



-- 
Best regards,
Krzysztof Kanas


--
Asylia ExchangeDefender Message Security: Click below to verify authenticity
http://www.exchangedefender.com/verify.asp?id=p8E8GTfa017441&from=k.kanas@kelvatek.com


