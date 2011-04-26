Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1DZNI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:08:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61521 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1DZNIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=kAm7n5xU49oUFaW7M8AEphZNwxz250P2jG73LIIjgCHyAYDm+kTGBzSsmddYLVMEnH
         Fi7sBXSpqcY5TPaSn0XZMuTobX1c4zxoqfruaz0toOO9lj6DUQ9CIJMOf8nBmtRTgjGr
         pyvy/+zvLUC+4C/o4HfJhFcrW1eFjHnkoFmM8=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <20110426070754.GB4154@gmail.com>
References: <20110426043835.GA4154@gmail.com>
	<20110426070754.GB4154@gmail.com>
Date: Tue, 26 Apr 2011 21:08:54 +0800
X-Google-Sender-Auth: EFF_XP889Ymsngw6L8WjYMleWjU
Message-ID: <BANLkTi=NMh50rGsir-kSvgWmGGM36NS4og@mail.gmail.com>
Subject: Re: [PATCH]Remove a warning
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org,
        joe@perches.com, randy.dunlap@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>On Tue, Apr 26, 2011 at 12:38:37PM +0800, Harry Wei wrote:

>> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
>> ---
>>  drivers/staging/wlan-ng/cfg80211.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/wlan-ng/cfg80211.c
>> b/drivers/staging/wlan-ng/cfg80211.c
>> index 6a71f52..7637839 100644
>> --- a/drivers/staging/wlan-ng/cfg80211.c
>> +++ b/drivers/staging/wlan-ng/cfg80211.c
>> @@ -273,7 +273,7 @@ exit:
>>  }
>>
>>  int prism2_set_default_key(struct wiphy *wiphy, struct net_device *dev,
>> -			   u8 key_index)
>> +			   u8 key_index, bool unicast, bool multicast)
It seems can fix the warning .
Thanks
>>  {
>>  	wlandevice_t *wlandev = dev->ml_priv;
>>
>> --
>> 1.7.0.4
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
