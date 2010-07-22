Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057Ab0GVWa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:30:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44295 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081Ab0GVWav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OWr8nLf48yhWDKr3y9evzObHnPW3Cyqjveza/HMvGAyR3e8jSHw77FqujhNEQzgM/i
         yfVpHupbeJaq3My2PmBJq0QRqQt1QXbMvBk+bLcDMPJr24HmzTJAIQrpyt8lMHA1SW1T
         BA4P3lB5J9Pal0sUzIc1AzothaIrMWHivluBg=
Message-ID: <4C48C6AC.3090005@gmail.com>
Date: Thu, 22 Jul 2010 15:31:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 35/35]Documentation/HOWTO update web address.
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>	<1279687982-29413-5-git-send-email-justinmattock@gmail.com> <20100722143836.ecbed9c7.rdunlap@xenotime.net>
In-Reply-To: <20100722143836.ecbed9c7.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 02:38 PM, Randy Dunlap wrote:
> On Tue, 20 Jul 2010 21:52:52 -0700 Justin P. Mattock wrote:
>
>> The patch below updates some borken web addresses.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   Documentation/HOWTO |    6 +++---
>>   1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/HOWTO b/Documentation/HOWTO
>> index 40ada93..365bda9 100644
>> --- a/Documentation/HOWTO
>> +++ b/Documentation/HOWTO
>> @@ -187,7 +187,7 @@ apply a patch.
>>   If you do not know where you want to start, but you want to look for
>>   some task to start doing to join into the kernel development community,
>>   go to the Linux Kernel Janitor's project:
>> -	http://janitor.kernelnewbies.org/
>> +	http://kernelnewbies.org/KernelJanitors	
>>   It is a great place to start.  It describes a list of relatively simple
>>   problems that need to be cleaned up and fixed within the Linux kernel
>>   source tree.  Working with the developers in charge of this project, you
>> @@ -315,7 +315,7 @@ process is tracked with the tool patchwork.  Patchwork offers a web
>>   interface which shows patch postings, any comments on a patch or
>>   revisions to it, and maintainers can mark patches as under review,
>>   accepted, or rejected.  Most of these patchwork sites are listed at
>> -http://patchwork.kernel.org/ or http://patchwork.ozlabs.org/.
>> +http://patchwork.kernel.org/.
>
>
> No need to drop patchwork.ozlabs.org -- it works.
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>


cool thanks! not sure why I did that(maybe hit the site at a wrong time 
or something).

I'll start over here with the first and go all the way through to the 
end..(after doing all of these kind of waxed me out...(needed to take a 
break)).

Justin P. Mattock
