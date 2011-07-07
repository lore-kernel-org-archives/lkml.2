Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1GGOrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:47:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63556 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1GGOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:47:15 -0400
Message-ID: <4E15C686.6030906@gmail.com>
Date: Thu, 07 Jul 2011 07:45:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]drivers:staging:rtl typo fix encryptiong to encryption.
References: <1309927897-25404-1-git-send-email-justinmattock@gmail.com> <1309927897-25404-2-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1107071519380.11049@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1107071519380.11049@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 06:19 AM, Jiri Kosina wrote:
>
> [ staging -- CCing Greg ]

alright.. if I need to resend let me know since I have a typo in the 
explanation line area

>
> On Tue, 5 Jul 2011, Justin P. Mattock wrote:
>
>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>
>> The beow patch fixes a typo.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
>>   drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    2 +-
>>   drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    2 +-
>>   3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
>> index 6cb31e1..552115c 100644
>> --- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
>> +++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
>> @@ -445,7 +445,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb,
>>   		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
>>   			bytes_per_frag -= IEEE80211_FCS_LEN;
>>
>> -		/* Each fragment may need to have room for encryptiong pre/postfix */
>> +		/* Each fragment may need to have room for encryption pre/postfix */
>>   		if (encrypt)
>>   			bytes_per_frag -= crypt->ops->extra_prefix_len +
>>   				crypt->ops->extra_postfix_len;
>> diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
>> index 995346d..d13be4c 100644
>> --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
>> +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
>> @@ -762,7 +762,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
>>   		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
>>   			bytes_per_frag -= IEEE80211_FCS_LEN;
>>
>> -		/* Each fragment may need to have room for encryptiong pre/postfix */
>> +		/* Each fragment may need to have room for encryption pre/postfix */
>>   		if (encrypt)
>>   			bytes_per_frag -= crypt->ops->extra_prefix_len +
>>   				crypt->ops->extra_postfix_len;
>> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
>> index ec7845e..59c45a5 100644
>> --- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
>> +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
>> @@ -723,7 +723,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
>>   		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
>>   			bytes_per_frag -= IEEE80211_FCS_LEN;
>>
>> -		/* Each fragment may need to have room for encryptiong pre/postfix */
>> +		/* Each fragment may need to have room for encryption pre/postfix */
>>   		if (encrypt)
>>   			bytes_per_frag -= crypt->ops->extra_prefix_len +
>>   				crypt->ops->extra_postfix_len;
>> --
>> 1.7.6
>>
>

