Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0HCECe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:02:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61963 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0HCECd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kGyFbYB6tTM/rOLpQXGz2bTI1XOBpXeWnUNO7otq58ln+eZsRAH+SnJ8pdkWwIx1h3
         5mZ+eSJZi4/vWgDrUOQf6bvgr672t9crz31Az9xVhSq9KXO5L1Evs0Y/F6txXoA75TCL
         wUN1Su5fKj8XULAMvGkSLyBjnMXZeNyRy9FcA=
Message-ID: <4C5794E8.50500@gmail.com>
Date: Mon, 02 Aug 2010 21:02:48 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Hendry <andrew.hendry@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers/usb/host/ehci-sched.c Fix typo
References: <1280806670-21009-1-git-send-email-justinmattock@gmail.com> <AANLkTi=cwXv6e5Biud5tFGHOESavFxLg2-4deNZ=pemj@mail.gmail.com>
In-Reply-To: <AANLkTi=cwXv6e5Biud5tFGHOESavFxLg2-4deNZ=pemj@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 08:52 PM, Andrew Hendry wrote:
> This may have been intended, it means if and only if.
> http://en.wikipedia.org/wiki/Iff
>

o.k.make sense to me..

> On Tue, Aug 3, 2010 at 1:37 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> The below patch fixes a typo in a comment.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/usb/host/ehci-sched.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
>> index 805ec63..3c170a9 100644
>> --- a/drivers/usb/host/ehci-sched.c
>> +++ b/drivers/usb/host/ehci-sched.c
>> @@ -1662,7 +1662,7 @@ itd_link_urb (
>>
>>   #define        ISO_ERRS (EHCI_ISOC_BUF_ERR | EHCI_ISOC_BABBLE | EHCI_ISOC_XACTERR)
>>
>> -/* Process and recycle a completed ITD.  Return true iff its urb completed,
>> +/* Process and recycle a completed ITD.  Return true if its urb completed,
>>   * and hence its completion callback probably added things to the hardware
>>   * schedule.
>>   *
>> --
>> 1.7.1.rc1.21.gf3bd6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>

cheers,

Justin P. Mattock
