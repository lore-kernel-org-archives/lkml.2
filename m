Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2DFGVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:21:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65276 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2DFGVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAGdaadbywdKu_8H5+MLMz_Sp_VC+JoUaw0-w-EiOqMGkTA30DA@mail.gmail.com>
References: <CANudz+uhw4LZ4EoDvp_eC2K23=Qm_ACPpM8TRq5p0t9=idKcSg@mail.gmail.com>
	<CAGdaadbywdKu_8H5+MLMz_Sp_VC+JoUaw0-w-EiOqMGkTA30DA@mail.gmail.com>
Date: Fri, 6 Apr 2012 14:21:38 +0800
Message-ID: <CANudz+up6=6Zx-9=7QndLqbbBLrApJG5C87ukWorpkisiK5bdw@mail.gmail.com>
Subject: Re: Some questions about high memory
From: loody <miloody@gmail.com>
To: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi mulyadi

2012/4/6 Mulyadi Santosa <mulyadi.santosa@gmail.com>:
> Hi...
>
> On Fri, Apr 6, 2012 at 09:19, loody <miloody@gmail.com> wrote:
>> hi all:
>> I am trying to write a driver for my block device which dma support
>> high memory copying.
>> I have register my device as "blk_bounce_any".
>> But my driver cannot see block layer pass high memory to me so far.
>
> perhaps because you need to kmap them first?
If I remember correctly, Kmap is used for mapping high memory into
kernel virtual memory.
Isn't that the job for block layer?

I thought once I declare my block device as "blk_bounce_any", the
block layer will pass the physical address of high memory to device.


>
> BTW, is it 32 bit or 64 bit Linux kernel?
32-bits linux kernel.

>
>> Is there any user/kernel test program which will purposely send high
>> memory for driver to use?
>> or is there any flag when opening a file in user mode that will use high memory?
>
> I recheck mmap and mmap manual page and I found none of such flag

does that mean mmap can specify which memory to map?
if that is true, which range I should use?

>
> --
> regards,
>
> Mulyadi Santosa
> Freelance Linux trainer and consultant
>
> blog: the-hydra.blogspot.com
> training: mulyaditraining.blogspot.com

Appreciate your help
