Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab0FCCa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:30:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36573 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab0FCCa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=T2l4MzT1bSYI5fM3E5XdXVj7JtVJLWmpRXU4aykwmdArdX30oTfqDTwLd3VkVYDaAj
         2Yspp0E593pUsL4yv71Y9rmPT1ifCxsSgXKZckB6dz39xjJPMLz7IWql/lt+6q3p3PPV
         h8ypVz+r709JBn0Yda/zevGRiCFrl9SDn47es=
MIME-Version: 1.0
In-Reply-To: <201006030201.13341.marek.vasut@gmail.com>
References: <20100305212708.GC21773@elf.ucw.cz> <1268048916.6477.9.camel@utx.utx.cz> 
	<20100308121634.GA14904@atrey.karlin.mff.cuni.cz> <201006030201.13341.marek.vasut@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 3 Jun 2010 10:30:06 +0800
Message-ID: <AANLkTikSotOdWIKqPpNi100rsVraIxZp6yZplIvaSo9m@mail.gmail.com>
Subject: Re: [URGENT] Re: bit errors on spitz + voipac
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Cyril Hrubis <metan@ucw.cz>,
       Stanislav Brabec <utx@penguin.cz>, dbaryshkov@gmail.com,
       arminlitzel@web.de, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org,
       Haojian Zhuang <haojian.zhuang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 8:01 AM, Marek Vasut <marek.vasut@gmail.com> wrote:
> Dne Po 8. března 2010 13:16:35 Cyril Hrubis napsal(a):
>> Hi!
>>
>> > - And I see display noise while CF Wi-Fi card is active.
>>
>> Forgotten about this one. See for yourself, notice short black vertical
>> lines flashing randomly.
>>
>> http://atrey.karlin.mff.cuni.cz/~metan/outgoing/zaurus_sickness.mpg
>
> This is not only case of spitz. I've seen LCD image falling apart on pxafb on
> Voipac PXA270 board. The image was like "torn in half and part of it was moved
> to right, the hole between staying white".
>
> This happened exactly when I started doing a DMA transfer from a harddrive
> attached through pata_pxa. It's perfectly replicable. If I disabled DMA and let
> it run only in PIO, the image was fine.
>
> I assume the corruption Pavel was seeing is related. My guess is the problems
> are caused when DMA between the CPU and a companion chip happens. I dunno if the
> DMA controller doesn't have enough power to supply LCD and the companion chip
> with data, but that's one of my guesses.
>
> btw. Adjusting the DMA descriptor length in pata_pxa didn't help.
>

If there is a FIFO attached, may need the FIFO status when the error happens.
And a dump of the DMA registers would also be helpful.
