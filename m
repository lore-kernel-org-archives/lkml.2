Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab0EBV2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 17:28:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36303 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945Ab0EBV2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 17:28:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Date: Sun, 2 May 2010 23:29:48 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Arve Hj??nnev??g" <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
References: <1272667021-21312-1-git-send-email-arve@android.com> <201005022210.54018.rjw@sisk.pl> <20100502205238.GC9051@elf.ucw.cz>
In-Reply-To: <20100502205238.GC9051@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005022329.48309.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 May 2010, Pavel Machek wrote:
> On Sun 2010-05-02 22:10:53, Rafael J. Wysocki wrote:
> > On Sunday 02 May 2010, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Adds /sys/power/policy that selects the behaviour of /sys/power/state.
> > > > After setting the policy to opportunistic, writes to /sys/power/state
> > > > become non-blocking requests that specify which suspend state to enter
> > > > when no suspend blockers are active. A special state, "on", stops the
> > > > process by activating the "main" suspend blocker.
> > > 
> > > As I explained before (and got no reply),  the proposed interface is
> > > ugly. It uses one sysfs file to change semantics of another one.
> > 
> > In fact this behavior was discussed at the LF Collab Summit and no one
> > involved had any problem with that.
> 
> Well, I explained why I disliked in previous mail in more details,

We do exactly the same thing with 'pm_test', so I'm not sure what the problem is.

> and neither you nor Arve explained why it is good solution.

Because it's less confusing.  Having two different attributes returning
almost the same contents and working in a slightly different way wouldn't be
too clean IMO.

Also it reduces code duplication slightly.

> I was not on LF Collab summit, so unfortunately I can't comment on that.
> 
> > > > Signed-off-by: Arve Hj??nnev??g <arve@android.com>
> > > 
> > > NAK.
> > 
> > Ignored.
> 
> WTF?

Literally.  I'm not going to take that NAK into consideration.

Rafael
