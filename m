Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024Ab2JCQQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:16:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964854Ab2JCQQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:16:50 -0400
Date: Wed, 3 Oct 2012 11:16:41 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121003161641.GA17709@sergelap>
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003132538.GE13192@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul E. McKenney (paulmck@linux.vnet.ibm.com):
> On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
> > This config item has not carried much meaning for a while now and is
> > almost always enabled by default. As agreed during the Linux kernel
> > summit, it should be removed. As a first step, remove it from being
> > listed, and default it to on. Once it has been removed from all
> > subsystem Kconfigs, it will be dropped entirely.
> > 
> > CC: Greg KH <gregkh@linuxfoundation.org>
> > CC: "Eric W. Biederman" <ebiederm@xmission.com>
> > CC: Serge Hallyn <serge.hallyn@canonical.com>
> > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > 
> > This is the first of a series of 202 patches removing EXPERIMENTAL from
> > all the Kconfigs in the tree. Should I send them all to lkml (with all
> > the associated CCs), or do people want to cherry-pick changes from my
> > tree? I don't want to needlessly flood the list.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
> > 
> > I figure this patch can stand alone to at least make EXPERIMENTAL go
> > away from the menus, and give us a taste of what the removal would do
> > to builds.
> 
> OK, I will bite...  How should I flag an option that is initially only
> intended for those willing to take some level of risk?

Sadly, the point is that EXPERIMENTAL is enabled in all distros and by
most users, so you *could* flag your feature CONFIG_EXPERIMENTAL, but
the only thing taht might accomplish is making you feel ok to be less
careful.

Of course, an alternative to this patch would be a purging - pull
the CONFIG_EXPERIMENTAL tag from all options which anyone might be
wanting to use by default.  Then let CONFIG_EXPERIMENTAL serve its
original purpose.

-serge
