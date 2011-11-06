Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1KFMKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 07:10:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab1KFMKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 07:10:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL pm/for-next] pm: freezer updates
Date: Sun, 6 Nov 2011 13:12:56 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111103223113.GR4417@google.com> <201111060101.26814.rjw@sisk.pl>
In-Reply-To: <201111060101.26814.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111061312.56256.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 06, 2011, Rafael J. Wysocki wrote:
> On Thursday, November 03, 2011, Tejun Heo wrote:
> > Hello, Rafael.
> > 
> > This is pull request for the following pending patches[ets].
> > 
> >  [1] freezer: fix various bugs and simplify implementation, take#2
> >  [2] usb_storage: don't use set_freezable_with_signal()
> >  [3] freezer: kill unused set_freezable_with_signal()
> >  [4] freezer: fix wait_event_freezable/__thaw_task races
> > 
> > The patches are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-freezer
> 
> I pulled this to linux-pm/pm-freezer, but there were merge conflicts that
> I'm not 100% have been resolved correctly.  Please double check if the
> resulting branch is OK.

I found a mismerge in the meantime, so the linux-pm/pm-freezer branch has
been re-created from scratch.  Please double check if it's correct.

I intend to start merging it into linux-next after 3.2-rc1 has been released.

Thanks,
Rafael
