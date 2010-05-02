Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0EBG4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 02:56:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50897 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753633Ab0EBG4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 02:56:42 -0400
Date: Sun, 2 May 2010 08:56:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj??nnev??g <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100502065635.GA1790@ucw.cz>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <1272667021-21312-2-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272667021-21312-2-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Adds /sys/power/policy that selects the behaviour of /sys/power/state.
> After setting the policy to opportunistic, writes to /sys/power/state
> become non-blocking requests that specify which suspend state to enter
> when no suspend blockers are active. A special state, "on", stops the
> process by activating the "main" suspend blocker.

As I explained before (and got no reply),  the proposed interface is
ugly. It uses one sysfs file to change semantics of another one.

> Signed-off-by: Arve Hj??nnev??g <arve@android.com>

NAK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
