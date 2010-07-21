Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0GUNh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:37:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39806 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0GUNhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EMoeqyUxVFVLdrob2frf9gkoKr/5lIL1h+NT6+xjINyt1tGEPMDdXXpTb7NEG8ES5e
         MML+P6anF/bNtBKAvztiNyRsfTJnyPPF4gna8XlUlFXitNsNrhZceknOZ8+ybRK+B7qy
         yYOv2wtMI7Doy0jEE5CTI8QESGtaLsoFXe6LI=
Message-ID: <4C46F840.6010908@gmail.com>
Date: Wed, 21 Jul 2010 06:38:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17]Documentation/blockdev/paride.txt update web address.
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com> <1279687926-29360-2-git-send-email-justinmattock@gmail.com> <4C46E289.6010009@grupopie.com>
In-Reply-To: <4C46E289.6010009@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 05:05 AM, Paulo Marques wrote:
> Justin P. Mattock wrote:
>> The patch below removes a web address due to me being unable
>> to locate this at all. If anybody knows the location let
>> me know and I'll resend.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   Documentation/blockdev/paride.txt |    5 -----
>>   1 files changed, 0 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/blockdev/paride.txt b/Documentation/blockdev/paride.txt
>> index e431267..11c4e3f 100644
>> --- a/Documentation/blockdev/paride.txt
>> +++ b/Documentation/blockdev/paride.txt
>> @@ -409,9 +409,4 @@ the list manager is a robot that will subscribe you using the reply
>>   address in your mail headers.  REMOVE any anti-spam gimmicks you may
>>   have in your mail headers, when sending mail to the list server.
>>
>> -You might also find some useful information on the linux-parport
>> -web pages (although they are not always up to date) at
>> -
>> -	http://www.torque.net/parport/
>> -
>
> I don't think removing an address like this is the best option. At least
> having the "old" address allows me to go to www.archive.org and find out
> a lot of useful information.
>
> Maybe just marking it as "(dead link)" and warning the respective
> maintainer would be better?
>


the whole tourque.net thing is dead.. it's not just this one here..
there must be at-least four or five of them throughout the Documentation.

is there a new updated location? or is www.archive.org already the new 
updated address?

Justin P. Mattock
