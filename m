Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2KUTPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:15:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40606 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab2KUTPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:15:47 -0500
Date: Wed, 21 Nov 2012 11:15:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
Message-ID: <20121121191542.GA23422@kroah.com>
References: <20121120235659.95001487.akpm@linux-foundation.org>
 <20121121184146.A9BCB8013C@viridian.itc.virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121184146.A9BCB8013C@viridian.itc.virginia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 01:41:46PM -0500, Bill Pemberton wrote:
> Andrew Morton writes:
> > 
> > On Tue, 20 Nov 2012 10:46:11 +0000 Grant Likely <grant.likely@secretlab.ca> wrote:
> > 
> > > On Sat, Nov 17, 2012 at 12:19 AM, Bill Pemberton <wfp5p@virginia.edu> wrote:
> > > > CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
> > > > it as on option code paths that check CONFIG_HOTPLUG will removed
> > > > along with the attributes __devexit_p, __devexit, __devinitconst, and
> > > > __devinitdata.
> > > >
> > > > I'll save the list from the mailbomb of this huge patchset.  The
> > > > patches themselves are going to Greg KH for the driver core tree.
> > > >
> > > >
> > > > Bill Pemberton (493):
> > > [...]
> > > >  2942 files changed, 11645 insertions(+), 12116 deletions(-)
> > > 
> > > So, I've got no problem with the reason for the change and I don't
> > > even think you need my ack for the bits that I maintain (though you
> > > have it if you want it). However, this looks like it is going to be
> > > /painful/. First of all it will touch a huge number of files in the
> > > tree. Yes the change is trivial, but it will require manual fixups on
> > > a lot of patches.
> > 
> > Yeah, this is dopey.  Send the script to Linus and ask him to run it
> > seven seconds before he releases -rc1, when everyone's trees are
> > empty(ish).  Or send him a single megapatch at that time.
> > 
> 
> I like the script idea for removing all the __dev markings.  Creating
> the patches in the first place was a game of whack-a-mole as various
> trees changed.

Linus doesn't like to take scripts, I had planned on queueing all of
these up that different subsystems maintainers didn't take, and pushing
the ones that did merge cleanly into -rc1.  Then, right after -rc1 is
out, go through the tree once more to get the stragglers.

Sound reasonable?

thanks,

greg k-h
