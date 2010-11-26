Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0KZIpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:45:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45477 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0KZIpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:45:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=AnLOI64Y2nKOhTuQFThJoChReW1tR0d2MeOOiyTGIK1ezEKA6Po1HGiVJ0IB2v9uFZ
         ldV/hhP17QEAdMXCmUXkUHULzjTqDEFZNMic3xkqZ7BzKUkLELEMe5VxGImjgm+D7tdw
         2FJZ8gBptLl9y50Yx3yQvbZ9qnbZpPpwQvPE4=
Date: Fri, 26 Nov 2010 11:45:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: i915: display doesn't get on back after returning from standby
 in 2.6.27-rc*
Message-ID: <20101126084538.GC12939@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Keith Packard <keithp@keithp.com>,
	Nick Bowler <nbowler@elliptictech.com>,
	Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	intel-gfx@lists.freedesktop.org,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <20101123123234.GA3791@tiehlicka.suse.cz>
 <20101125155828.GC9754@tiehlicka.suse.cz>
 <20101125161058.GA5831@elliptictech.com>
 <yunr5e9qjyf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunr5e9qjyf.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 11:31:04AM -0800, Keith Packard wrote:
> On Thu, 25 Nov 2010 11:10:58 -0500, Nick Bowler <nbowler@elliptictech.com> wrote:
> > On 2010-11-25 16:58 +0100, Michal Hocko wrote:
> > > [Let's add Rafael for regression tracking]
> > > 
> > > On Tue 23-11-10 13:32:34, Michal Hocko wrote:
> > > > Hi,
> > > > since early 2.6.37 (I haven't bisected when exactly) my screen doesn't
> > > > get on after it got into standby mode. I have to either change to a
> > > > text console and back (if it gets to standby by the screen saver) or
> > > > close the lid on my laptop if I try:
> > > > xset dpms force standby
> > [...]
> > > > Is this a known issue?
> > 
> > I suspect that all of the following are the same issue:
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=23122
> >   https://bugzilla.kernel.org/show_bug.cgi?id=23472
> >   https://bugs.freedesktop.org/show_bug.cgi?id=31803
> 
> I've provided a couple of fixes that might be relevant here -- neither
> kernel nor user mode were setting the tracked DPMS state of the outputs
> to ON when doing mode setting, which caused all kinds of comedy. These
> should fix 23472 and 31803. I'm not entirely sure what's up with 23122,
> but it's possible that it's the same issue.
> 

Where are the patches?  I pulled drm-next but I don't see them.

regards,
dan carpenter
