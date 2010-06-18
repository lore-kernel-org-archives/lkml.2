Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab0FRUMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:12:41 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:34895 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933525Ab0FRUM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:12:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sdRXRNuEOK+Hrsaj/gb8AnrbptQNDVyyibq3Hkjwhtd/qtvYx/qzDgrz32av04nXHitWnj57L6wVZUbaaN5YQtatH8gw+rPy8eoo0Cw/2zT496mBuPZnogV4I0w3Drz1;
Date: Fri, 18 Jun 2010 13:10:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create
 duplicate filename ... XVR-600 related?
Message-ID: <20100618131049.462ca7ce@virtuousgeek.org>
In-Reply-To: <201006122052.25204.rjw@sisk.pl>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
	<19472.47559.578732.941291@pilspetsen.it.uu.se>
	<19475.45707.157935.788004@pilspetsen.it.uu.se>
	<201006122052.25204.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jun 2010 20:52:25 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday, June 12, 2010, Mikael Pettersson wrote:
> > Mikael Pettersson writes:
> >  > Rafael J. Wysocki writes:
> >  >  > On Wednesday, June 09, 2010, Mikael Pettersson wrote:
> >  >  > > Rafael J. Wysocki wrote:
> >  >  > > > This message has been generated automatically as a part of a summary report
> >  >  > > > of recent regressions.
> >  >  > > > 
> >  >  > > > The following bug entry is on the current list of known regressions
> >  >  > > > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> >  >  > > > know (either way).
> >  >  > > > 
> >  >  > > > 
> >  >  > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16161
> >  >  > > > Subject		: [2.6.35-rc1 regression] sysfs: cannot create duplicate filename =
> >  >  > > > ... XVR-600 related?
> >  >  > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> >  >  > > > Date		: 2010-06-01 19:57 (8 days old)
> >  >  > > > Message-ID	: <19461.26166.427857.612983@pilspetsen.it.uu.se>
> >  >  > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D127542227511925&w=3D2
> >  >  > > 
> >  >  > > The bug is still there in 2.6.35-rc2. I haven't checked post-rc2 git snapshots.
> >  >  > 
> >  >  > Please test post-rc2 too.
> >  > 
> >  > The bug is still there in 2.6.35-rc2-git4.
> > 
> > The bug appears to be gone in 2.6.35-rc3.
> 
> Good.
> 
> > I don't know which commit actually fixed it.
> 
> Well, it would be useful information, but it's much more important it's not
> there anymore.

I reverted the symlink patch that was causing the trouble.  The root
cause is elsewhere though; it seems some firmwares report duplicate PCI
slot numbers...

-- 
Jesse Barnes, Intel Open Source Technology Center
