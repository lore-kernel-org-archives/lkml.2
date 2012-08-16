Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab2HPODH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:03:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48707 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2HPODD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:03:03 -0400
Date: Thu, 16 Aug 2012 16:03:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@linuxfoundation.org>, Sameer Nanda <snanda@chromium.org>,
        rob@landley.net, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] power: add knob for printing device resume times
Message-ID: <20120816140301.GA16230@elf.ucw.cz>
References: <20120522202453.GA30723@kroah.com>
 <201206151200.21225.rjw@sisk.pl>
 <20120615140924.GA30392@kroah.com>
 <201206161557.37591.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206161557.37591.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2012-06-16 15:57:37, Rafael J. Wysocki wrote:
> On Friday, June 15, 2012, Greg KH wrote:
> > On Fri, Jun 15, 2012 at 12:00:20PM +0200, Rafael J. Wysocki wrote:
> > > On Friday, June 15, 2012, Greg KH wrote:
> > > > On Wed, May 23, 2012 at 09:45:32AM -0700, Sameer Nanda wrote:
> > > > > Added a new knob called /sys/power/pm_print_times. Setting it to 1
> > > > > enables printing of time taken by devices to suspend and resume.
> > > > > Setting it to 0 disables this printing (unless overridden by
> > > > > initcall_debug kernel command line option).
> > > > > 
> > > > > Signed-off-by: Sameer Nanda <snanda@chromium.org>
> > > > > cc: Greg KH <gregkh@linuxfoundation.org>
> > > > > cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > cc: Steven Rostedt <rostedt@goodmis.org>
> > > > > ---
> > > > >  Documentation/ABI/testing/sysfs-power |   13 ++++++++++++
> > > > >  drivers/base/power/main.c             |    4 +-
> > > > >  drivers/base/power/power.h            |   11 ++++++++++
> > > > >  kernel/power/main.c                   |   34 +++++++++++++++++++++++++++++++++
> > > > >  4 files changed, 60 insertions(+), 2 deletions(-)
> > > > 
> > > > This patch fails against the linux-next tree, care to fix it up so that
> > > > I can apply it?
> > > 
> > > I'd prefer it to go through my tree if you don't mind.
> > 
> > Not at all, feel free to put:
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > When it shows up again.
> 
> I've just used the original one, it only needed a documentation merge conflict
> fixed.
> 
> Queued up for 3.6.

Umm. Is it good idea? 60 LoC is pretty much for something that already
has command line option?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
