Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1KFQsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:48:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33986 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1KFQsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:48:02 -0500
Date: Sun, 6 Nov 2011 08:47:55 -0800
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL pm/for-next] pm: freezer updates
Message-ID: <20111106164755.GA13699@google.com>
References: <20111103223113.GR4417@google.com>
 <201111060101.26814.rjw@sisk.pl>
 <201111061312.56256.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111061312.56256.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Sun, Nov 06, 2011 at 01:12:56PM +0100, Rafael J. Wysocki wrote:
> On Sunday, November 06, 2011, Rafael J. Wysocki wrote:
> > On Thursday, November 03, 2011, Tejun Heo wrote:
> > > Hello, Rafael.
> > > 
> > > This is pull request for the following pending patches[ets].
> > > 
> > >  [1] freezer: fix various bugs and simplify implementation, take#2
> > >  [2] usb_storage: don't use set_freezable_with_signal()
> > >  [3] freezer: kill unused set_freezable_with_signal()
> > >  [4] freezer: fix wait_event_freezable/__thaw_task races
> > > 
> > > The patches are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-freezer
> > 
> > I pulled this to linux-pm/pm-freezer, but there were merge conflicts that
> > I'm not 100% have been resolved correctly.  Please double check if the
> > resulting branch is OK.
> 
> I found a mismerge in the meantime, so the linux-pm/pm-freezer branch has
> been re-created from scratch.  Please double check if it's correct.
> 
> I intend to start merging it into linux-next after 3.2-rc1 has been released.

fake_signal_wake_up() merging seems wrong.  It should be calling
signal_wake_up() with @resume == 0.  Other than that, everything looks
correct to me.

Thank you.

-- 
tejun
