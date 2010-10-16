Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0JPPiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:38:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44245 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab0JPPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=smieOfx4fCDtWdBdNkYshCsHtmr1h7DTrOxKxobllkxnRlLhZz75ad1Xy6a9Sx3loV
         rZkstDlAPF0MtGsibKcnKRBFnePCeg+fQ88E2XSlf0lU0tDPqRYf9WaoWAwQIfVeKrJu
         DAk8GrnNmG4mnQnNd1u83k/Fr8CwKRGSz2uZc=
Message-ID: <4CB9C6FF.9060707@gmail.com>
Date: Sat, 16 Oct 2010 08:38:39 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: trivial@kernel.org, jkosina@suse.cz, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/2 v6]Update broken web addresses in arch directory.
References: <1287169117-7374-1-git-send-email-justinmattock@gmail.com> <alpine.OSX.2.00.1010161759140.293@localhost>
In-Reply-To: <alpine.OSX.2.00.1010161759140.293@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2010 12:48 AM, Finn Thain wrote:
>
> On Fri, 15 Oct 2010, Justin P. Mattock wrote:
>
>> index 3499fad..0fd6a08 100644
>> --- a/arch/arm/mach-pxa/am200epd.c
>> +++ b/arch/arm/mach-pxa/am200epd.c
>> @@ -10,7 +10,7 @@
>>    * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
>>    *
>>    * This work was made possible by help and equipment support from E-Ink
>> - * Corporation. http://support.eink.com/community
>> + * Corporation. http://www.support.eink.com/
>
> These are both dead links now. The old one is is in the web archive
> anyway.
>
>
>>    *
>>    * This driver is written to be used with the Metronome display controller.
>>    * on the AM200 EPD prototype kit/development kit with an E-Ink 800x600
>> diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
>> index 993d75e..01aa021 100644
>> --- a/arch/arm/mach-pxa/am300epd.c
>> +++ b/arch/arm/mach-pxa/am300epd.c
>> @@ -8,7 +8,7 @@
>>    * more details.
>>    *
>>    * This work was made possible by help and equipment support from E-Ink
>> - * Corporation. http://support.eink.com/community
>> + * Corporation. http://www.support.eink.com/
>
> Same here.
>
>
>>    *
>>    * This driver is written to be used with the Broadsheet display controller.
>>    * on the AM300 EPD prototype kit/development kit with an E-Ink 800x600
>
>> diff --git a/arch/powerpc/include/asm/hydra.h b/arch/powerpc/include/asm/hydra.h
>> index 1ad4eed..d529a2c 100644
>> --- a/arch/powerpc/include/asm/hydra.h
>> +++ b/arch/powerpc/include/asm/hydra.h
>> @@ -10,7 +10,7 @@
>>    *
>>    *	© Copyright 1995 Apple Computer, Inc. All rights reserved.
>>    *
>> - *  It's available online from http://chrp.apple.com/MacTech.pdf.
>> + *  It's available online from http://www.cpu.lu/~mlan/ftp/MacTech.pdf.
>
> You should remove the trailing "." or else insert angle brackets.
>
>
>>    *  You can obtain paper copies of this book from computer bookstores or by
>>    *  writing Morgan Kaufmann Publishers, Inc., 340 Pine Street, Sixth Floor, San
>>    *  Francisco, CA 94104. Reference ISBN 1-55860-393-X.
>
>
> Thanks.
>
> Finn


alright..  before I resend both of these.. if anybody see's anything 
else let me know..

cheers,

Justin P. Mattock
