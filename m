Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1EUPYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 11:24:24 -0400
Received: from zinan.dashjr.org ([173.242.112.54]:40649 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab1EUPYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 11:24:20 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: Major 2.6.38 regression ignored?
Date: Sat, 21 May 2011 11:23:53 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r4; KDE/4.6.2; x86_64; ; )
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com>
In-Reply-To: <013811$4lfs6@fmsmga002.fm.intel.com>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211123.56053.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 21, 2011 4:41:45 AM Chris Wilson wrote:
> On Fri, 20 May 2011 11:08:56 -0700, Ray Lee <ray-lk@madrabbit.org> wrote:
> > [ Adding Chris Wilson (author of the problematic patch) and Rafael
> > Wysocki to the message ]
> > 
> > On Fri, May 20, 2011 at 10:06 AM, Luke-Jr <luke@dashjr.org> wrote:
> > > I submitted https://bugzilla.kernel.org/show_bug.cgi?id=33662 a month
> > > ago against 2.6.38. Now 2.6.39 was just released without the
> > > regression being addressed. This bug makes the system unusable... Some
> > > guys on IRC suggested I
> > > email, so here it is.
> > 
> > See the bugzilla entry for the bisection history.
> 
> Which has nothing to do with Luke's bug. Considering the thousand things
> that can go wrong during X starting, without a hint as to which it is nigh
> on impossible to debug except by trial and error. If you set up
> netconsole, does the kernel emit an OOPS with it's last dying breath?

Why assume it's a different bug? I would almost wonder if it might affect 
all Sandy Bridge GPUs. In any case, I no longer have the original 
motherboard (it was recalled, as I said in the first post), nor even the 
revision of it (it had other issues that weren't being fixed). I *assume* I 
will have the same problem with my new motherboard (Intel DQ67SW), but I 
haven't verified that yet. I'll be sure to try a netconsole when I have to 
reboot next and get a chance to try the most recent 2.6.38 and .39 kernels, 
but at the moment it seems reasonable to address the problem bisected in the 
bug, even if it turns out to be different.
