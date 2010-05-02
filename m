Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab0EBUw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 16:52:58 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37357 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758754Ab0EBUwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 16:52:55 -0400
Date: Sun, 2 May 2010 22:52:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve Hj??nnev??g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100502205238.GC9051@elf.ucw.cz>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <1272667021-21312-2-git-send-email-arve@android.com>
 <20100502065635.GA1790@ucw.cz>
 <201005022210.54018.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005022210.54018.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-05-02 22:10:53, Rafael J. Wysocki wrote:
> On Sunday 02 May 2010, Pavel Machek wrote:
> > Hi!
> > 
> > > Adds /sys/power/policy that selects the behaviour of /sys/power/state.
> > > After setting the policy to opportunistic, writes to /sys/power/state
> > > become non-blocking requests that specify which suspend state to enter
> > > when no suspend blockers are active. A special state, "on", stops the
> > > process by activating the "main" suspend blocker.
> > 
> > As I explained before (and got no reply),  the proposed interface is
> > ugly. It uses one sysfs file to change semantics of another one.
> 
> In fact this behavior was discussed at the LF Collab Summit and no one
> involved had any problem with that.

Well, I explained why I disliked in previous mail in more details, and
neither you nor Arve explained why it is good solution.

I was not on LF Collab summit, so unfortunately I can't comment on that.

> > > Signed-off-by: Arve Hj??nnev??g <arve@android.com>
> > 
> > NAK.
> 
> Ignored.

WTF?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
