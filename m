Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0EZRIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:08:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59166 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab0EZRID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ewNsJ6Jm42J4qFjPQ57VoTTrjXTXuxQS/EnBpAQOmUtUQoKXMJb63ogJdP28ADRfwA
         XaTiaPTFBTejkORYkRT1jpS3O6hG17f4Zw8hPqMMoDW1IaIaUpFwUcHOJILxGTeX953o
         GScn+YONe0i/G+g9dGe2toUOQe5rFq34+Mnb4=
Message-ID: <4BFD5584.2040604@gmail.com>
Date: Wed, 26 May 2010 10:08:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: ath9k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       mcgrog@gmail.com
Subject: Re: [ath9k-devel] [PATCH]wireless:ath9k Fix ath_print in xmit.c
References: <1274892555-10422-1-git-send-email-justinmattock@gmail.com> <AANLkTim1qNEXJB38p_MEQxfjhWRe1-kPfNFq3JL11qgl@mail.gmail.com>
In-Reply-To: <AANLkTim1qNEXJB38p_MEQxfjhWRe1-kPfNFq3JL11qgl@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 10:05 AM, Luis R. Rodriguez wrote:
> On Wed, May 26, 2010 at 9:49 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>    
>> ath_print in xmit.c should say "Reseting hardware"
>> instead of Reaseting HAL!(since HAL is being fazed out).
>> dmesg shows:
>> [ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
>> [ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!
>>
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 3db1917..2a0558e 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>>                 int r;
>>
>>                 ath_print(common, ATH_DBG_FATAL,
>> -                         "Unable to stop TxDMA. Reset HAL!\n");
>> +                         "Unable to stop TxDMA. Reseting hardware!\n");
>>      
> Thanks for the patch but you need to send this to John, cc linux-wireless.
>
>    Luis
>
>    

I'll resend with the proper Cc's

Justin P. mattock
