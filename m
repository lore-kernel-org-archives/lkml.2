Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2KNIDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:03:53 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42614 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2KNIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:03:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121103101926.4e48cf8e7f3f1d3de90e45a2@canb.auug.org.au>
References: <CAMuHMdXhYNQ_7JOC3u7CS41mxgSKkuFYA7QdjZgeBawqMZQ9-g@mail.gmail.com>
	<20121103101926.4e48cf8e7f3f1d3de90e45a2@canb.auug.org.au>
Date: Wed, 14 Nov 2012 09:03:51 +0100
X-Google-Sender-Auth: o2-ZGbkkhoAG60aPV1qkbdYauhA
Message-ID: <CAMuHMdWeDsAtmUq_TEFRAEY_gikAVoh=-mqwwp9OzOXobyWo+A@mail.gmail.com>
Subject: Re: ccache: FATAL: Could not create /scratch/kisskb/ccache
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <michael@ellerman.id.au>
Cc: Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sat, Nov 3, 2012 at 12:19 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Fri, 2 Nov 2012 19:44:48 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> http://kisskb.ellerman.id.au/kisskb/buildresult/7458505/
>>
>> ccache: FATAL: Could not create
>> /scratch/kisskb/ccache/d/7/f9e308f728ef43aaa482aefb9a00a2-852386.o.tmp.stdout.Sprygo.5748
>> (permission denied?)
>> make[4]: *** [drivers/media/rc/ene_ir.o] Error 1
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/7461979/
>>
>> ccache: FATAL: Could not create
>> /scratch/kisskb/ccache/5/e/47d893acad42c07542edec1f826579-1842636.o.tmp.stdout.Sprygo.557
>> (permission denied?)
>> make[3]: *** [net/core/sock.o] Error 1
>
> Well, that is weird.  I can't find any reason for that to happen :-(
>
> I'll have a chat with the kisskb guy when I next see him.  Thanks for the
> heads up.

As code is migrating to Linus' tree, it's spreading from the linux-next to the
linus branch, e.g.:
http://kisskb.ellerman.id.au/kisskb/buildresult/7536268/
ccache: FATAL: Could not create
/scratch/kisskb/ccache/1/3/a44cddb2457ad89fe496b0c82b0a09-1211932.o.tmp.stdout.Sprygo.2788
(permission denied?)
make[3]: *** [drivers/block/aoe/aoecmd.o] Error 1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
