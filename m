Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0GOG3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:29:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0GOG3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:29:07 -0400
Date: Wed, 14 Jul 2010 22:35:43 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Randy Dunlap <randy.dunlap@oracle.com>, alsa-devel@alsa-project.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [alsa-devel] [PATCH] driver core: remove
	CONFIG_SYSFS_DEPRECATED
Message-ID: <20100715053543.GA4416@suse.de>
References: <20100709185450.GA29473@kroah.com> <20100714163852.b3c09930.akpm@linux-foundation.org> <AANLkTinIy1z7226W0ylNfDdHXBp16Wt7aYBKQYY1o5t9@mail.gmail.com> <20100715041400.GA2583@suse.de> <AANLkTik1G3E6RP8cEK2JoPcqZp0Q16nK9F-4tAtXWnPk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik1G3E6RP8cEK2JoPcqZp0Q16nK9F-4tAtXWnPk@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 03:00:31PM +1000, Dave Airlie wrote:
> On Thu, Jul 15, 2010 at 2:14 PM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Jul 15, 2010 at 10:24:18AM +1000, Dave Airlie wrote:
> >> On Thu, Jul 15, 2010 at 9:38 AM, Andrew Morton
> >> <akpm@linux-foundation.org> wrote:
> >> > On Fri, 9 Jul 2010 11:54:50 -0700
> >> > Greg Kroah-Hartman <gregkh@suse.de> wrote:
> >> >
> >> >> This is no longer needed by any userspace tools, so it's safe to
> >> >> remove.
> >>
> >> Also still used for booting mainline kernels on RHEL5 userspaces.
> >
> > Really? ?I thought that was fixed a long time ago. ?What kernel was
> > RHEL5 originally based on?
> >
> > And note that no RHEL5 user is going to be using a .36 kernel on their
> > system, that's a completely unsupported and unadvised situation. ?Heck,
> > I'd be amazed if a .34 kernel.org kernel boots on the thing, does it?
> >
> 
> I think some people do it internally, last time I did it was to test
> something I was backporting, so you want to make sure the upstream
> version boots and the backported version also boots on the same
> hw/userspace.
> 
> original kernel was 2.6.18.

Yes, that was the number, but does it really look anything like a .18
kernel.org release?  :)

I'll test this out next week.

thanks,

greg k-h
