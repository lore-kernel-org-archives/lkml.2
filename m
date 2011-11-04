Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1KDAkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:40:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab1KDAkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:40:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH pm-for-3.2 2/2] freezer: revert 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Fri, 4 Nov 2011 01:42:48 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@redhat.com>
References: <20111103230749.GS4417@google.com> <201111040124.34015.rjw@sisk.pl> <20111104002708.GV4417@google.com>
In-Reply-To: <20111104002708.GV4417@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111040142.48840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 04, 2011, Tejun Heo wrote:
> On Fri, Nov 04, 2011 at 01:24:33AM +0100, Rafael J. Wysocki wrote:
> > > Just to be sure, as the commit which changed fake_signal_wake_up() to
> > > use KILLABLE wakeup is already mainline, these two will have to be
> > > pushed as fixes after some time in this devel cycle.
> > 
> > Yes, they are 3.2 material and I'm going to push them in the next few days
> > along with a number of other PM-related fixes/cleanups.  Is that OK?
> 
> Yeap, definitely.  Just got a bit worried that it was going into
> linux-next.  Thanks. :)

As long as the merge window is open linux-next contains material for the
current development cycle.

Thanks,
Rafael
