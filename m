Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2FOOJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:09:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43718 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab2FOOJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:09:29 -0400
Date: Fri, 15 Jun 2012 07:09:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sameer Nanda <snanda@chromium.org>, rob@landley.net, len.brown@intel.com,
        pavel@ucw.cz, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] power: add knob for printing device resume times
Message-ID: <20120615140924.GA30392@kroah.com>
References: <20120522202453.GA30723@kroah.com>
 <1337791532-15820-1-git-send-email-snanda@chromium.org>
 <20120615001924.GA8874@kroah.com>
 <201206151200.21225.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206151200.21225.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 12:00:20PM +0200, Rafael J. Wysocki wrote:
> On Friday, June 15, 2012, Greg KH wrote:
> > On Wed, May 23, 2012 at 09:45:32AM -0700, Sameer Nanda wrote:
> > > Added a new knob called /sys/power/pm_print_times. Setting it to 1
> > > enables printing of time taken by devices to suspend and resume.
> > > Setting it to 0 disables this printing (unless overridden by
> > > initcall_debug kernel command line option).
> > > 
> > > Signed-off-by: Sameer Nanda <snanda@chromium.org>
> > > cc: Greg KH <gregkh@linuxfoundation.org>
> > > cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > cc: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  Documentation/ABI/testing/sysfs-power |   13 ++++++++++++
> > >  drivers/base/power/main.c             |    4 +-
> > >  drivers/base/power/power.h            |   11 ++++++++++
> > >  kernel/power/main.c                   |   34 +++++++++++++++++++++++++++++++++
> > >  4 files changed, 60 insertions(+), 2 deletions(-)
> > 
> > This patch fails against the linux-next tree, care to fix it up so that
> > I can apply it?
> 
> I'd prefer it to go through my tree if you don't mind.

Not at all, feel free to put:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

When it shows up again.

thanks,

greg k-h
