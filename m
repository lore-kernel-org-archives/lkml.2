Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2BPXMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:12:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56730 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab2BPXMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:12:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Subject: Re: [linux-pm] Corrupted files after suspend to disk
Date: Fri, 17 Feb 2012 00:16:14 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>,
        linux-pm@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, esandeen@redhat.com
References: <201202162251.47063.rjw@sisk.pl> <Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org> <CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com>
In-Reply-To: <CAFLxGvwWBWTmv+uUH87UB3Ly31hjVU5kWpSyihGDKj6_8oc6WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202170016.14313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 17, 2012, richard -rw- weinberger wrote:
> On Thu, Feb 16, 2012 at 11:26 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 16 Feb 2012, Rafael J. Wysocki wrote:
> >
> >> > FWIW, we've been seeing a number of hard to diagnose failures
> >> > with suspend to disk for the last few releases in Fedora.
> >> > Eric Sandeen has been chasing https://bugzilla.redhat.com/show_bug.cgi?id=744275
> >> > for a while, but there's no smoking gun that really explains what's
> >> > getting into these states. Further complicating things, is that it
> >> > doesn't seem to be 100% reproducable.
> >>
> >> I wonder if that's reproducible with the filesystems freezing patch I posted
> >> some time ago (it will need some rebasing to apply to the current mainline or
> >> 3.2.y).
> 
> Where can I find this patch?
> I'll happily test it.
> But it may take some time as the bug is not easy to reproduce.

This is the last version posted:

http://marc.info/?l=linux-kernel&m=132775832509351&w=4

However, it only may help if you use the kernel-based hibernation i.e.
"echo disk > /sys/power/state" (that may be worth testing without the
patch too, but Fedora is using this AFAICS, so it probably has that
problem too).

Thanks,
Rafael
