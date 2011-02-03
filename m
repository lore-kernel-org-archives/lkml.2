Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab1BCTJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:09:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430Ab1BCTJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:09:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.38-rc3-git1: Reported regressions 2.6.36 -> 2.6.37
Date: Thu, 3 Feb 2011 20:09:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Carlos R. Mafra" <crmafra2@gmail.com>,
        Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera> <AANLkTikELiGS+fM5WguZS=Fo-sSXmej1UnKWqCFmnE0k@mail.gmail.com> <s5haaid3xos.wl%tiwai@suse.de>
In-Reply-To: <s5haaid3xos.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102032009.17100.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 03, 2011, Takashi Iwai wrote:
> At Thu, 3 Feb 2011 07:42:05 -0800,
> Linus Torvalds wrote:
> > 
> > On Thu, Feb 3, 2011 at 3:23 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> > > On Thu  3.Feb'11 at  1:03:41 +0100, Rafael J. Wysocki wrote:
> > >>
> > >> If you know of any other unresolved post-2.6.36 regressions, please let us know
> > >> either and we'll add them to the list.  Also, please let us know if any
> > >> of the entries below are invalid.
> > >
> > > I'm sorry if I'm overlooking something, but as far as I can see the regression
> > > reported here:
> > >
> > > https://lkml.org/lkml/2011/1/24/457
> > >
> > > is not in the list (update on that report: reverting that commit on top of
> > > 2.6.37 fixes the issue).
> > 
> > Ok, added Keith and Dave to the cc, since they are the signers of that commit.
> > 
> > > After some time, I also ended up finding an earlier report in the kernel bugzilla
> > > which I think is the same regression (it was bisected to the same commit):
> > >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=24982
> > >
> > > but I do not see it in the list either, even though it's marked as a
> > > regression in the bugzilla.
> > >
> > > The issue was also present in 2.6.38-rc2 last time I tested.
> > 
> > Just to confirm, can you also check -rc3? I'm pretty sure nothing has
> > changed, but there were a few drm patches after -rc2, so it's alsways
> > good to double-check.
> 
> The problem I reported in the bugzilla above is still present in
> 2.6.38-rc3.  I'm pretty sure that's the same issue as Carlos' case.

I added https://bugzilla.kernel.org/show_bug.cgi?id=24982 to the list of
post-2.6.36 regressions for further tracking.

Thanks,
Rafael
