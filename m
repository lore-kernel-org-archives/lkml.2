Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab1GKQ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:57:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64758 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab1GKQ5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:57:16 -0400
MIME-Version: 1.0
In-Reply-To: <4E1B208D.1000708@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
	<1310160851-26415-1-git-send-email-james_p_freyensee@linux.intel.com>
	<CAMuHMdV5OC6ENMK9uOXZBv3Z3MrOMiu0P6az5baM9jdRFwSAvA@mail.gmail.com>
	<4E1B208D.1000708@linux.intel.com>
Date: Mon, 11 Jul 2011 18:57:14 +0200
X-Google-Sender-Auth: StVNqO-eqEGpmE2NiEjsgpZWVs8
Message-ID: <CAMuHMdWnTn2FpsKo73NsLpDs=Pr_aM7fO01FzyU6xHuDbxLBAQ@mail.gmail.com>
Subject: Re: [PATCH] PTI implicit declaration fix.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        randy.dunlap@oracle.com, sfr@canb.auug.org.au,
        christophe.guerard@intel.com, pranav.k.sanghadia@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 18:10, J Freyensee
<james_p_freyensee@linux.intel.com> wrote:
> On 07/09/2011 01:08 AM, Geert Uytterhoeven wrote:
>> On Fri, Jul 8, 2011 at 23:34,<james_p_freyensee@linux.intel.com>  wrote:
>>>
>>> From: J Freyensee<james_p_freyensee@linux.intel.com>
>>>
>>> In a certain compile configuration, functions like
>>> 'kmalloc' and 'copy_from_user' were coming up as
>>> implicit errors.  This patch adds slab.h and
>>> uaccess.h to the driver.
>>>
>>> Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
>>> Acked-by: Geert Uytterhoeven<geert@linux-m68k.org>
>>
>> Please don't add "Acked-by" lines before people have ack'ed your patches.
>>
>
> Okay...so should I re-send this patch out without the Acked-by in it? Or is
> it okay this time and next time please do this?

It's OK for now. It's a trivial patch anyway.

>>> Signed-off-by: J Freyensee<james_p_freyensee@linux.intel.com>
>>> ---
>>>  drivers/misc/pti.c |    2 ++
>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
>>> index 8653bd0..4ba4e5f 100644
>>> --- a/drivers/misc/pti.c
>>> +++ b/drivers/misc/pti.c
>>> @@ -22,6 +22,8 @@
>>>  */
>>>
>>>  #include<linux/init.h>
>>> +#include<linux/slab.h>
>>> +#include<linux/uaccess.h>
>>>  #include<linux/sched.h>
>>>  #include<linux/interrupt.h>
>>>  #include<linux/console.h>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
