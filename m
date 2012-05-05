Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2EEKyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:54:13 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:34737 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2EEKyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:54:12 -0400
Date: Sat, 5 May 2012 03:52:49 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/6] twl4030: Various fixes for charing-from-USB
Message-ID: <20120505105249.GA20875@lizard>
References: <20120425072931.20124.56635.stgit@notabene.brown>
 <CANOLnOOQDxu-P=yTN6159XJANq-_FSCtZ4rBt69NSCPjLz1Rjw@mail.gmail.com>
 <20120430093002.472dfdde@notabene.brown>
 <20120505104910.GA19590@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120505104910.GA19590@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 03:49:10AM -0700, Anton Vorontsov wrote:
> On Mon, Apr 30, 2012 at 09:30:02AM +1000, NeilBrown wrote:
> > > > Following are a collection of patches that I've need using for a while
> > > > to make sure the charge-from-usb on my GTA04 works.
> > > > Hopefully I've included the right people in the recipient list :-)
> > > 
> > > You missed the power supply maintainers - ./scripts/get_maintainer.pl
> > > is usually good at finding the right people, although their
> > > MAINTAINERS entry could be better I guess..
> > > 
> > > 
> > 
> > I guess you mean:
> > 
> > POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
> > M:	Anton Vorontsov <cbou@mail.ru>
> > M:	David Woodhouse <dwmw2@infradead.org>
> > T:	git git://git.infradead.org/battery-2.6.git
> > S:	Maintained
> > F:	include/linux/power_supply.h
> > F:	drivers/power/power_supply*
> > 
> > 
> > get_maintainer.pl didn't find them.  The F: line seems to say they aren't
> > interested in individual drivers...
> 
> This is a 'bug', of course. :-) Thanks for the report.
> 
> This is what I've just applied:
> 
> - - - -
> MAINTAINERS: Fix 'F' entry for the power supply class
> 
> For some reason the maintainers file only specifies power
> supply core files.
> 
> We're surely interested in individual drivers as well, so fix
> the entry.
> 
> Reported-by: NeilBrown <neilb@suse.de>

Oh, Grazvydas Ignotas noticed this too. I added
Reported-by: Grazvydas Ignotas <notasas@gmail.com> as well.
Just to be precise. ;-)

Thanks folks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
