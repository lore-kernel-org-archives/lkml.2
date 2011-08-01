Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1HALtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:49:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37654 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab1HALtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110729112054.eaf20e1875990b05e9545d81@canb.auug.org.au>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
	<20110728071556.GA6497@elte.hu>
	<20110728154229.GA19589@windriver.com>
	<20110729112054.eaf20e1875990b05e9545d81@canb.auug.org.au>
Date: Mon, 1 Aug 2011 13:49:05 +0200
X-Google-Sender-Auth: bZGE9ph-PVT_PXkCIDT3_RCYJ7I
Message-ID: <CAMuHMdUJbZsJ1Q0DM4h3uGVCpe+q=28oxphbLzQ6kW4bn9ZoHA@mail.gmail.com>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, Jul 29, 2011 at 03:20, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Thu, 28 Jul 2011 11:42:29 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>> [Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage] On 28/07/2011 (Thu 09:15) Ingo Molnar wrote:
>>
>> > * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>> >
>> > > I don't think there really is any rocket science or contentious
>> > > stuff here. It is a sensible cleanup that adds organization and
>> > > speeds up compiles. The RFC I'm hoping for is more about how/when
>> > > we want to get this in tree.
>> >
>> > I'd suggest to stick it into linux-next ASAP, leave there for a few
>> > days and after fixing any potential fallout send it Linuswards.
>>
>> Hi Stephen,
>>
>> Would you please add this to linux-next?
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git#module.h-split
>
> OK, I will add it today.

This causes several failures in m68k defconfig (and allmodconfig, FWIW):

http://kisskb.ellerman.id.au/kisskb/buildresult/4428037/
(http://kisskb.ellerman.id.au/kisskb/buildresult/4414683/)

Still recovering from holidays, so no patches attached.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
