Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab0EEL2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:28:21 -0400
Received: from mail9.surf-town.net ([212.97.132.49]:43274 "EHLO
	mailgw6.surf-town.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754286Ab0EEL2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:28:19 -0400
X-Greylist: delayed 1550 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2010 07:28:19 EDT
X-Spam-Score: 0.1
Message-ID: <4BE1503A.7020702@viketoft.se>
Date: Wed, 05 May 2010 13:02:18 +0200
From: Jakob Viketoft <jakob@viketoft.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: eric.y.miao@gmail.com
CC: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, minimumlaw@rambler.ru
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
References: <20100416100126.GI30801@buzzloop.caiaq.de> <4BC8493D.60900@bitsim.com> 	<20100416112820.GM30801@buzzloop.caiaq.de> <20100416112931.GN30801@buzzloop.caiaq.de> 	<n2mf17812d71005050045x4359dfeu2f563c3ac0a42223@mail.gmail.com> 	<20100505080015.GD30801@buzzloop.caiaq.de> <u2nf17812d71005050228x3c19060n9a096d7bcc1db4d6@mail.gmail.com> 	<20100505094405.GG30801@buzzloop.caiaq.de> <j2tf17812d71005050247ybaf95719l27a9f1f403436b7f@mail.gmail.com> 	<20100505095339.GH30801@buzzloop.caiaq.de> <z2jf17812d71005050321m2520f76cv95801b0539800db5@mail.gmail.com>
In-Reply-To: <z2jf17812d71005050321m2520f76cv95801b0539800db5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I didn't see this first as the e-mail address jakob.viketoft@bitsim.com 
is being shut down (changing jobs).

Eric Miao wrote:
> On Wed, May 5, 2010 at 5:53 PM, Daniel Mack <daniel@caiaq.de> wrote:
>> On Wed, May 05, 2010 at 05:47:14PM +0800, Eric Miao wrote:
>>> On Wed, May 5, 2010 at 5:44 PM, Daniel Mack <daniel@caiaq.de> wrote:
>>>>> And I'm not able to find
>>>>> drivers/pcmcia/pxa2xx_colibri.c as well.
>>>> Erm - how is that related to the patch in question?
>>>>
>>> The error seems to be (as in previous mail):
>>>
>>>  CC      drivers/pcmcia/pxa2xx_colibri.o
>>> In file included from drivers/pcmcia/pxa2xx_colibri.c:25:
>>> arch/arm/mach-pxa/include/mach/colibri.h:13: error: expected ')'
>>> before '*' token
>>> make[2]: *** [drivers/pcmcia/pxa2xx_colibri.o] Error 1
>>> make[1]: *** [drivers/pcmcia] Error 2
>>> make: *** [drivers] Error 2
>> Ah, sorry.

The pcmcia-patch isn't my work, but that of Alex A. Mihaylov 
(minimumlaw@rambler.ru). I was hoping that he would be pushing those 
bits upstream separately, but I think some things needs to me shifted 
around a bit to be accepted.

>>
>>> And actually, inclusion of <mach/mfp.h> is better to be placed where it's
>>> used, i.e. drivers/pcmcia/pxa2xx_colibri.c.
>> In general I agree, but in this case, mfp_t is used in this header file,
>> so every piece of code which includes colibri.h will need both
>> <mach/mfp.h> and <net/ax88796.h>. And as this is a rule for all users, I
>> think the right place for the inclusion is the header file?
>>
> 
> I see.
> 
> Acked-by: Eric Miao <eric.y.miao@gmail.com>

Thanks.

> 
> 
>> Apart from that, this fix will work for both mainline and -stable, which
>> makes things easier :)
>>
> 
> I'll take it to -pxa then.

Sounds good!

	/Jakob

