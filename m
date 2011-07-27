Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1G0EKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:10:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62415 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1G0EKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:10:07 -0400
Message-ID: <4E2F8F8F.7060106@gmail.com>
Date: Tue, 26 Jul 2011 21:09:51 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Remove extra semicolon's in the kernel.
References: <1311704763-6682-1-git-send-email-justinmattock@gmail.com> <m2zkk0q1ex.fsf@igel.home>
In-Reply-To: <m2zkk0q1ex.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> diff --git a/arch/ia64/include/asm/mca_asm.h b/arch/ia64/include/asm/mca_asm.h
>> index dd2a5b1..d57d3c0 100644
>> --- a/arch/ia64/include/asm/mca_asm.h
>> +++ b/arch/ia64/include/asm/mca_asm.h
>> @@ -46,11 +46,11 @@
>>    *	1. Put 0x7 in bits 61 thru 63.
>>    */
>>   #define DATA_PA_TO_VA(addr,temp)							\
>> -	mov	temp	= 0x7	;;							\
>> +	mov	temp	= 0x7;							\
>
> Double semicolons are significant in the ia64 assembler language.

appologize for the delay(have this thing called work!)
anyways:

ahh.. I was confused if one semicolon should be used, or two(some say 
yes, some say no etc..) and now I know for the ia64 two is used.
(thanks for the info on this)

>
>> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
>> index 4d40384..e187f1f 100755
>> --- a/scripts/setlocalversion
>> +++ b/scripts/setlocalversion
>> @@ -101,7 +101,7 @@ scm_version()
>>   		# Are there uncommitted changes?
>>   		# These are represented by + after the changeset id.
>>   		case "$hgid" in
>> -			*+|*+\ *) printf '%s' -dirty ;;
>> +			*+|*+\ *) printf '%s' -dirty;
>
> Double semicolons are significant in the Bourne shell language.
>

I was torn on what to do with this. part of me said yeah it should stay, 
but then another part of me, said well maybe it was a mistake due to the 
whitespace(so I sent it out).

I will resend without the above, if there is any others let me know, and 
thank you for the help/info

> Andreas.
>

