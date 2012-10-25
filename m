Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897Ab2JYRxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:53:48 -0400
Received: from mail.agmk.net ([91.192.224.71]:46884 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934720Ab2JYRxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:53:47 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Martin Peres <martin.peres@labri.fr>
Cc: Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lekensteyn <lekensteyn@gmail.com>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Date: Thu, 25 Oct 2012 19:53:40 +0200
Message-ID: <2097113.JL2tUTAZjM@localhost>
User-Agent: KMail/4.9.1 (Linux/3.7.0-rc2-00145-g4864ccb; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50827174.7070109@labri.fr>
References: <1724445.dN2yMEzN6d@localhost> <20121020092647.GA3186@fancy-poultry.org> <50827174.7070109@labri.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 of October 2012 11:40:04 Martin Peres wrote:
> On 20/10/2012 11:26, Heinz Diehl wrote:
> > On 20.10.2012, Linus Torvalds wrote:
> >
> >> Added more appropriate people to this. Added both i915 and nouveau
> >> people, since apparently that fine piece of hardware has both.
> >>
> >> Guys, any ideas?
> >
> > Plese see https://lkml.org/lkml/2012/10/19/371 , this is the same
> > thing going on. Reverting
> >
> >   Ben Skeggs <bskeggs@redhat.com>
> >   drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 64KiB
> >
> > fixes the problem.
> 
> Can you test the attached patch too ? I rebased the previous one I sent 
> on top on 3.7-rc1 as I accidentally used an older version.
> 
> Martin

Hi all once again,

i've tested current 3.7.0-rc2-00145-g4864ccb and it works fine (boots and works
with builtin core-i7 intel video) but i have one more question - what is the reason
of loading nouveau driver for laptops with nvidia optimus and enabling vga switcheroo
which doesn't work in such (optimus) cases. or maybe i've missed something
and switchereoo works with optimus?

BR,
Paweł.

