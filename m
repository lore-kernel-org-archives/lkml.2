Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2FRB0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 21:26:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55590 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2FRB0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 21:26:49 -0400
Date: Sun, 17 Jun 2012 18:26:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sameer Nanda <snanda@chromium.org>, rob@landley.net, len.brown@intel.com,
        pavel@ucw.cz, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] (was: Re: [PATCH v2] power: add knob for printing device
 resume times)
Message-ID: <20120618012644.GC13192@kroah.com>
References: <20120522202453.GA30723@kroah.com>
 <20120615140924.GA30392@kroah.com>
 <201206161557.37591.rjw@sisk.pl>
 <201206162236.21611.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206162236.21611.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 10:36:21PM +0200, Rafael J. Wysocki wrote:
> On Saturday, June 16, 2012, Rafael J. Wysocki wrote:
> > On Friday, June 15, 2012, Greg KH wrote:
> > > On Fri, Jun 15, 2012 at 12:00:20PM +0200, Rafael J. Wysocki wrote:
> > > > On Friday, June 15, 2012, Greg KH wrote:
> > > > > On Wed, May 23, 2012 at 09:45:32AM -0700, Sameer Nanda wrote:
> > > > > > Added a new knob called /sys/power/pm_print_times. Setting it to 1
> > > > > > enables printing of time taken by devices to suspend and resume.
> > > > > > Setting it to 0 disables this printing (unless overridden by
> > > > > > initcall_debug kernel command line option).
> > > > > > 
> > > > > > Signed-off-by: Sameer Nanda <snanda@chromium.org>
> > > > > > cc: Greg KH <gregkh@linuxfoundation.org>
> > > > > > cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > cc: Steven Rostedt <rostedt@goodmis.org>
> > > > > > ---
> > > > > >  Documentation/ABI/testing/sysfs-power |   13 ++++++++++++
> > > > > >  drivers/base/power/main.c             |    4 +-
> > > > > >  drivers/base/power/power.h            |   11 ++++++++++
> > > > > >  kernel/power/main.c                   |   34 +++++++++++++++++++++++++++++++++
> > > > > >  4 files changed, 60 insertions(+), 2 deletions(-)
> > > > > 
> > > > > This patch fails against the linux-next tree, care to fix it up so that
> > > > > I can apply it?
> > > > 
> > > > I'd prefer it to go through my tree if you don't mind.
> > > 
> > > Not at all, feel free to put:
> > > 
> > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > When it shows up again.
> > 
> > I've just used the original one, it only needed a documentation merge conflict
> > fixed.
> > 
> > Queued up for 3.6.
> 
> I propose the following patch on top of this one.  The details are in the
> changelog.
> 
> If anyone has any objections, please let me know.

No objection from me at all, thanks for cleaning this up:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
