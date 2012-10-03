Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311Ab2JCRNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:13:23 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57999 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2JCRNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:13:22 -0400
Date: Wed, 3 Oct 2012 09:47:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121003164712.GF2527@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
 <20121003161702.GA22008@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003161702.GA22008@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100317-7408-0000-0000-000008FF822D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 09:17:02AM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 03, 2012 at 06:25:38AM -0700, Paul E. McKenney wrote:
> > On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
> > > This config item has not carried much meaning for a while now and is
> > > almost always enabled by default. As agreed during the Linux kernel
> > > summit, it should be removed. As a first step, remove it from being
> > > listed, and default it to on. Once it has been removed from all
> > > subsystem Kconfigs, it will be dropped entirely.
> > > 
> > > CC: Greg KH <gregkh@linuxfoundation.org>
> > > CC: "Eric W. Biederman" <ebiederm@xmission.com>
> > > CC: Serge Hallyn <serge.hallyn@canonical.com>
> > > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > CC: Andrew Morton <akpm@linux-foundation.org>
> > > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > > 
> > > This is the first of a series of 202 patches removing EXPERIMENTAL from
> > > all the Kconfigs in the tree. Should I send them all to lkml (with all
> > > the associated CCs), or do people want to cherry-pick changes from my
> > > tree? I don't want to needlessly flood the list.
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
> > > 
> > > I figure this patch can stand alone to at least make EXPERIMENTAL go
> > > away from the menus, and give us a taste of what the removal would do
> > > to builds.
> > 
> > OK, I will bite...  How should I flag an option that is initially only
> > intended for those willing to take some level of risk?
> 
> In the text say "You really don't want to enable this option, use at
> your own risk!"  Or something like that :)

OK, so the only real hope for experimental features is to refrain from
creating a config option for them, so that people wishing to use them
must modify the code?  Or is the philosophy that we keep things out of
tree until we are comfortable with distros turning them on?

							Thanx, Paul

