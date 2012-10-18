Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2JRLNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:13:55 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:61653 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2JRLNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:13:52 -0400
MIME-Version: 1.0
In-Reply-To: <507FD383.5050302@snapgear.com>
References: <20121018103713.0ccb63374964501c3d8d99a5@canb.auug.org.au>
	<20121018103826.c8e1312904747b31caa376f6@canb.auug.org.au>
	<507F78B0.70808@snapgear.com>
	<CAMuHMdWX2ZVNcz1Ubsk0W3HH7qcBQhctaWSFVq=x+YwbuUE9YA@mail.gmail.com>
	<507FD383.5050302@snapgear.com>
Date: Thu, 18 Oct 2012 13:13:50 +0200
X-Google-Sender-Auth: M1VtdyMo5kfNIp9iPI-lMwbSzOs
Message-ID: <CAMuHMdV3hm7U2bjQVteYB4=eu9pcrtvY87ttvdTMu+VWXiTZFw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with the tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Oct 18, 2012 at 12:01 PM, Greg Ungerer <gerg@snapgear.com> wrote:
> On 10/18/2012 03:51 PM, Geert Uytterhoeven wrote:
>> On Thu, Oct 18, 2012 at 5:34 AM, Greg Ungerer <gerg@snapgear.com> wrote:
>>> On 18/10/12 09:38, Stephen Rothwell wrote:
>>>> On Thu, 18 Oct 2012 10:37:13 +1100 Stephen Rothwell
>>>> <sfr@canb.auug.org.au>
>>>> wrote:
>>>>> Today's linux-next merge of the m68knommu tree got conflicts in
>>>>> arch/m68k/include/asm/termios.h, arch/m68k/include/uapi/asm/auxvec.h,
>>>>> arch/m68k/include/uapi/asm/msgbuf.h,
>>>>> arch/m68k/include/uapi/asm/sembuf.h,
>>>>> arch/m68k/include/uapi/asm/shmbuf.h,
>>>>> arch/m68k/include/uapi/asm/socket.h,
>>>>> arch/m68k/include/uapi/asm/sockios.h and
>>>>> arch/m68k/include/uapi/asm/termbits.h between commit 10b3a979347d
>>>>> ("UAPI:
>>>>> (Scripted) Disintegrate arch/m68k/include/asm") from the m68k-current
>>>>> tree and various commits from the m68knommu tree that use the
>>>>> asm-generic
>>>>> versions.
>>>>>
>>>>> I just deleted all those files and added the following merge fix patch
>>>>> and can carry the fix as necessary.
>>>>>
>>>>> I think that this is the correct thing to do ...
>>>
>>>
>>>
>>> I think that is right. Thanks.
>>
>>
>> I still have to do a proper review of your changes (I noticed a few
>> things I have
>> to double-check). After that, I guess it's easiest if I take your
>> patch, updated for
>> the UAPI disintegration?
>
>
> Sure. My patches are based on 3.7-rc1. I am not sure if David's changes
> are going upstream in a future rc, or are for 3.8.

I plan to submit hem later this week, but first I have to send out my sys_kcmp
wire up patch so I can receive your ack ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
