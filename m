Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0FXHbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:31:14 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45592 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0FXHbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PNxZhl+G4B4xyWRi2AVcjbnE+xs01ePbpOhPlD5rIR11WOpfduOCjDhESuhF/hYMeQ
         WkBXMyqv9P3hjOSNAaVzIyYo+53T4tOCwHc1vnEVCl9ipCWTOBo9DQ8+S4LGFT7GdPfV
         yMbFIHk7XsMJxXoqlqputaJHM5XZkknxH8Vpo=
MIME-Version: 1.0
In-Reply-To: <20100622165509.GB11336@tux>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com>
	<1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com>
	<20100622165509.GB11336@tux>
Date: Thu, 24 Jun 2010 13:01:11 +0530
Message-ID: <AANLkTikHiPKPD5myvn8bycPAS4f9rBkPvbag6if7p23O@mail.gmail.com>
Subject: Re: [PATCH] mm: kmemleak: Change kmemleak default buffer size
From: Sankar P <sankar.curiosity@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
       "rnagarajan@novell.com" <rnagarajan@novell.com>,
       "teheo@novell.com" <teheo@novell.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 10:25 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Jun 21, 2010 at 11:58:29PM -0700, Sankar P wrote:
>> If we try to find the memory leaks in kernel that is
>> compiled with 'make defconfig', the default buffer size
>> seem to be inadequate. Change the buffer size from
>> 400 to 1000, which is sufficient in most cases.
>>
>> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
>
> What's your full name? Please read the "Developer's Certificate of Origin 1.1"
> It says:
>
> then you just add a line saying
>
>        Signed-off-by: Random J Developer <random@developer.example.org>
>
> using your real name (sorry, no pseudonyms or anonymous contributions.)
>
>
> Also you may want to post on a new thread instead of using this old thread
> unless the maintainer is reading this and wants to pick it up.
>

In our part of the world, we dont have lastnames. We just use the
first letter of our father's name as the last name.

I will send the updated patch as a new mail, I thought it will be
easier to follow if all mails belongs to the same thread.

Thanks

>  Luis
>
>> ---
>>  arch/sh/configs/sh7785lcr_32bit_defconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
>> index 71f39c7..b02e5ae 100644
>> --- a/arch/sh/configs/sh7785lcr_32bit_defconfig
>> +++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
>> @@ -1710,7 +1710,7 @@ CONFIG_SCHEDSTATS=y
>>  # CONFIG_DEBUG_OBJECTS is not set
>>  # CONFIG_DEBUG_SLAB is not set
>>  CONFIG_DEBUG_KMEMLEAK=y
>> -CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
>> +CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=1000
>>  # CONFIG_DEBUG_KMEMLEAK_TEST is not set
>>  CONFIG_DEBUG_PREEMPT=y
>>  # CONFIG_DEBUG_RT_MUTEXES is not set
>> --
>> 1.6.4.2
>>
>



-- 
Sankar P
http://psankar.blogspot.com
