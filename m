Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1BFNEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 08:04:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1BFNEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 08:04:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marc Koschewski <marc@osknowledge.org>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Date: Sun, 6 Feb 2011 14:04:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com> <AANLkTimURab9M5-LQxU0wjo=gEVBjHyv6osudadq4nNO@mail.gmail.com> <20110206122101.GC22960@marc.osknowledge.org>
In-Reply-To: <20110206122101.GC22960@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102061404.24146.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 06, 2011, Marc Koschewski wrote:
> I've the NX stuff disabled, so to say DEBUG_RODATA=n and it doesn't resume... so
> what's next?

Did you actually try to revert the NX commits or go back to the version of the
kernel where they aren't present?

Also, what's the last known working kernel?

> I use an i7 with 32bit code as I think 64bit is a) useless for me

You're most probably wrong, because memory management is mush simpler in the
64-bit mode.  Basically, if your machine supports 64-bitness, you should use
it.

> and b) I just plugged my old HDD into my new machine.

Well, that's a good reason to stay backwards-compatible.

Thanks,
Rafael


> > >> I reverted the specified commit and my box still suffers the
> > >> resume-turns-into-cold-boot behavior. Retried two times with the commit reverted
> > >> on top of HEAD...
> > >
> > > The cold-boot problem is very likely irrelevant with i915 patches.
> > > I've got the same issue with and without the i915 fix patches on test
> > > machines here.
> > >
> > Yeah its the 32-bit NX stuff most likely if you are using 32-bit kernels.
