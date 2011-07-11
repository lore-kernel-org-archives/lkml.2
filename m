Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab1GKQKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:10:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:7916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009Ab1GKQKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:10:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,515,1304319600"; 
   d="scan'208";a="26543219"
Message-ID: <4E1B208D.1000708@linux.intel.com>
Date: Mon, 11 Jul 2011 09:10:53 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        randy.dunlap@oracle.com, sfr@canb.auug.org.au,
        christophe.guerard@intel.com, pranav.k.sanghadia@intel.com
Subject: Re: [PATCH] PTI implicit declaration fix.
References: <james_p_freyensee@linux.intel.com> <1310160851-26415-1-git-send-email-james_p_freyensee@linux.intel.com> <CAMuHMdV5OC6ENMK9uOXZBv3Z3MrOMiu0P6az5baM9jdRFwSAvA@mail.gmail.com>
In-Reply-To: <CAMuHMdV5OC6ENMK9uOXZBv3Z3MrOMiu0P6az5baM9jdRFwSAvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2011 01:08 AM, Geert Uytterhoeven wrote:
> On Fri, Jul 8, 2011 at 23:34,<james_p_freyensee@linux.intel.com>  wrote:
>> From: J Freyensee<james_p_freyensee@linux.intel.com>
>>
>> In a certain compile configuration, functions like
>> 'kmalloc' and 'copy_from_user' were coming up as
>> implicit errors.  This patch adds slab.h and
>> uaccess.h to the driver.
>>
>> Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
>> Acked-by: Geert Uytterhoeven<geert@linux-m68k.org>
>
> Please don't add "Acked-by" lines before people have ack'ed your patches.
>

Okay...so should I re-send this patch out without the Acked-by in it? 
Or is it okay this time and next time please do this?

>> Signed-off-by: J Freyensee<james_p_freyensee@linux.intel.com>
>> ---
>>   drivers/misc/pti.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
>> index 8653bd0..4ba4e5f 100644
>> --- a/drivers/misc/pti.c
>> +++ b/drivers/misc/pti.c
>> @@ -22,6 +22,8 @@
>>   */
>>
>>   #include<linux/init.h>
>> +#include<linux/slab.h>
>> +#include<linux/uaccess.h>
>>   #include<linux/sched.h>
>>   #include<linux/interrupt.h>
>>   #include<linux/console.h>
>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds

