Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab2FPNwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:52:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45485 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab2FPNwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:52:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] power: add knob for printing device resume times
Date: Sat, 16 Jun 2012 15:57:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Sameer Nanda <snanda@chromium.org>, rob@landley.net, len.brown@intel.com,
        pavel@ucw.cz, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
References: <20120522202453.GA30723@kroah.com> <201206151200.21225.rjw@sisk.pl> <20120615140924.GA30392@kroah.com>
In-Reply-To: <20120615140924.GA30392@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206161557.37591.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 15, 2012, Greg KH wrote:
> On Fri, Jun 15, 2012 at 12:00:20PM +0200, Rafael J. Wysocki wrote:
> > On Friday, June 15, 2012, Greg KH wrote:
> > > On Wed, May 23, 2012 at 09:45:32AM -0700, Sameer Nanda wrote:
> > > > Added a new knob called /sys/power/pm_print_times. Setting it to 1
> > > > enables printing of time taken by devices to suspend and resume.
> > > > Setting it to 0 disables this printing (unless overridden by
> > > > initcall_debug kernel command line option).
> > > > 
> > > > Signed-off-by: Sameer Nanda <snanda@chromium.org>
> > > > cc: Greg KH <gregkh@linuxfoundation.org>
> > > > cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > > cc: Steven Rostedt <rostedt@goodmis.org>
> > > > ---
> > > >  Documentation/ABI/testing/sysfs-power |   13 ++++++++++++
> > > >  drivers/base/power/main.c             |    4 +-
> > > >  drivers/base/power/power.h            |   11 ++++++++++
> > > >  kernel/power/main.c                   |   34 +++++++++++++++++++++++++++++++++
> > > >  4 files changed, 60 insertions(+), 2 deletions(-)
> > > 
> > > This patch fails against the linux-next tree, care to fix it up so that
> > > I can apply it?
> > 
> > I'd prefer it to go through my tree if you don't mind.
> 
> Not at all, feel free to put:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> When it shows up again.

I've just used the original one, it only needed a documentation merge conflict
fixed.

Queued up for 3.6.

Thanks,
Rafael
