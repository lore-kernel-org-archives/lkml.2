Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2GSVaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:30:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36106 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GSVaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:30:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120719182235.GG8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	<20120713210240.GG1707@redhat.com>
	<CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	<20120719152618.GD16873@home.goodmis.org>
	<20120719154521.GC8469@zod.bos.redhat.com>
	<1342714088.12353.33.camel@gandalf.stny.rr.com>
	<20120719171918.GD8469@zod.bos.redhat.com>
	<1342722036.26179.40.camel@x61.thuisdomein>
	<20120719182235.GG8469@zod.bos.redhat.com>
Date: Thu, 19 Jul 2012 23:30:01 +0200
X-Google-Sender-Auth: BVrhgYYKWbiuld1hO5km928sYpw
Message-ID: <CAMuHMdViB6eCLzX12pH8kQT6AeTrXmmma1kb-BSdf2qMtXkMgA@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 8:22 PM, Josh Boyer <jwboyer@redhat.com> wrote:
> On Thu, Jul 19, 2012 at 08:20:36PM +0200, Paul Bolle wrote:
>> On Thu, 2012-07-19 at 13:19 -0400, Josh Boyer wrote:
>> > kconfig already spits out warnings for symbols being selected that
>> > don't exist.
>>
>> Does it? Since when does it do that? Or do you mean select in a more
>> general way (not just meaning Kconfig's "select" statement)?
>
> I believe Alan was more correct than me when he said it was 'make
> oldconfig' that produced the warnings.

Indeed, no warnings for all these remaining "select MISC_DEVICES"
(patch sent to remove these).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
