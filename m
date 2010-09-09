Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0IIXYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:24:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64808 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab0IIXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AqdFa5DG14yvaBg3NUCwBmSn0fMEsmPd+4KlA+LI0QVUmBqrC1rz2sdf5sbWWalcjs
         Ao0C9B0SH2Ihb1rMXRoeg2t1BZQPvpjtJgPlgR/TFx2aJ5CdPoDPOcPtO9YB4UpkLASm
         a/ghNjGBGnmbM4Qz1iMCr6gDWy/+MK4P8/Sl8=
Message-ID: <4C896CE6.50100@gmail.com>
Date: Thu, 09 Sep 2010 16:25:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 217/223]drivers/video/Kconfig Update broken web addresses.
References: <1284072367-8485-1-git-send-email-justinmattock@gmail.com> <1284072367-8485-7-git-send-email-justinmattock@gmail.com> <20100909155540.78b771ba.rdunlap@xenotime.net>
In-Reply-To: <20100909155540.78b771ba.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2010 03:55 PM, Randy Dunlap wrote:
> On Thu,  9 Sep 2010 15:46:01 -0700 Justin P. Mattock wrote:
>
>> Below you will find an Update to a broken web address.
>> Please let me know if this needs to be changed.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/video/Kconfig |   10 +++++-----
>>   1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
>> index 8b31fdf..a15a092 100644
>> --- a/drivers/video/Kconfig
>> +++ b/drivers/video/Kconfig
>> @@ -49,7 +49,7 @@ menuconfig FB
>>   	  You need an utility program called fbset to make full use of frame
>>   	  buffer devices. Please read<file:Documentation/fb/framebuffer.txt>
>>   	and the Framebuffer-HOWTO at
>> -	<http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.2.html>  for more
>> +	<http://www.faqs.org/docs/Linux-HOWTO/Framebuffer-HOWTO.html>  for more
>>   	  information.
>
> http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.3.html
>
> although this is a tar.gz file in reality.  :(
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

alright... think I posted this one in the past in Doc/* but cant 
remember(the patch is on my other machine to check). Ill have to check 
this one again..(so many of them..(dont think I want to see a web 
address for a while...))

:-)

Justin P. Mattock
