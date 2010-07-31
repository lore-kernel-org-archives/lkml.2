Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0GaP4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 11:56:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49185 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0GaP4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 11:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jk3LBAlUUPJCBEsjg7GC9mVNcfr7aP0hJxJUvsxra7oTAjNrkp1AdvZ7xjt4HWBmR4
         Wa09TBQG1TQGQO1c1YonD8xfQdGQVk92VVL5drzfjidzua9rP8WdMbBpIOJXNjRoV3Pa
         4Bpfgv5TBT5DC37aOvBjgT9iRss5Fx5EVlgzE=
Message-ID: <4C54479E.7000004@gmail.com>
Date: Sat, 31 Jul 2010 08:56:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 93/93]Documentation/RCU/RTFP.txt update web address.
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com> <1279688215-29628-3-git-send-email-justinmattock@gmail.com> <20100731150407.GC2470@linux.vnet.ibm.com>
In-Reply-To: <20100731150407.GC2470@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2010 08:04 AM, Paul E. McKenney wrote:
> On Tue, Jul 20, 2010 at 09:56:43PM -0700, Justin P. Mattock wrote:
>> The patch below updates a broken web address.
>
> Good catch!!!
>
> Reviewed-by: Paul E. McKenney<paulmck@linux.vnet.ibm.com>
>

Thanks for having a look..
glad you did this because I just looked over the one big patch I sent 
for these and realized I left this one out.
(I'll have to resend again and double check to make sure..)

>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   Documentation/RCU/RTFP.txt |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
>> index 5aea459..c43460d 100644
>> --- a/Documentation/RCU/RTFP.txt
>> +++ b/Documentation/RCU/RTFP.txt
>> @@ -606,7 +606,7 @@ Suparna Bhattacharya"
>>   ,Year="2006"
>>   ,pages="v2 123-138"
>>   ,note="Available:
>> -\url{http://www.linuxsymposium.org/2006/view_abstract.php?content_key=184}
>> +\url{http://www.linuxsymposium.org/2006/index_2006.php}
>>   \url{http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf}
>>   [Viewed January 1, 2007]"
>>   ,annotation="
>> --
>> 1.7.1.rc1.21.gf3bd6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

Justin P. Mattock
