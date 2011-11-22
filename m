Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1KVQKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:10:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61499 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab1KVQKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:10:01 -0500
MIME-Version: 1.0
In-Reply-To: <4ECAFDAD.5040801@panasas.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
	<4EBAB5F7.80000@xenotime.net>
	<CA+5PVA6tBx4i1XZ+AF=uaOsjYCshG9CzXHWjnJcsJ=z1qw1F4A@mail.gmail.com>
	<4ECAFDAD.5040801@panasas.com>
Date: Tue, 22 Nov 2011 11:10:00 -0500
Message-ID: <CA+5PVA7a2GgX_FVWTnQtV5VXK1x9UhqLHSzqZHaibcGH+8a+NA@mail.gmail.com>
Subject: Re: Linux 3.2-rc1
From: Josh Boyer <jwboyer@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 8:41 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 11/09/2011 09:28 AM, Josh Boyer wrote:
>>
>> Fedora uses those.  We also used the -gitX snapshot patches when they
>> were generated, but now we do that by hand (which we also did for the
>> -rcX patches while kernel.org was down.)
>>
>> josh
>
> My god that totally-brain-dead Fedora Kernel rpm generation.
>
> RANT a head should be skipped!!
>
> I wish there was a strait forward way to point to a Kernel
> git tree HEAD and say "make rpm", which is simply the tar
> of the "make modules_install" and the "make install" output
> + a simple script to manipulate grub.conf

I'm actually thinking about creating an exploded source Fedora git
tree.  I just haven't gotten around to it yet because it's not exactly
straight-forward.

> Not today's Fedora-Kernel git tree which is not a Linux
> git tree at all but those patches above + stable.
> Any simple tree moments needs to involve black patch magic
> and fear of hell. (Don't try this at home)

There's a wiki page on building your own Fedora kernel.  It's really
not that complicated.

> Actually the "grub-selector" should have been it's own
> rpm. And each Kernel can/should be it's own independent
> (none conflicting, right) package. I know, I know, it tries
> to be that, but it is not. For example I want a low-latency
> rt Kernel as a side choice for any Kernel, and so on...

Fedora has no interest in the kernels it isn't building, so we're not
really going to split things out separately like that because it
serves us no purpose.

> Throw away that monstrous  Fedora-Kernel-tree. There is
> only one Kernel tree it is called Linux. You can do your
> own back/forward port branches based on stable to your
> heart's content with out inventing a new totally different
> patches tree.

The git tree you're looking at is for the buildsystem to create RPMs.
That requires a spec file, tarballs, and patches.  It can't build from
exploded source (at least not easily), so you're comparing apples to
oranges somewhat.

Anyway, if/when I get an exploded source git tree created for Fedora,
I'll post about it to the Fedora kernel list.

josh
