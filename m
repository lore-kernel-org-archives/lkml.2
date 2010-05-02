Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0EBG5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 02:57:38 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50932 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753633Ab0EBG5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 02:57:37 -0400
Date: Sun, 2 May 2010 08:57:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj??nnev??g <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 3/8] PM: suspend_block: Abort task freezing if a
 suspend_blocker is active.
Message-ID: <20100502065731.GB1790@ucw.cz>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <1272667021-21312-2-git-send-email-arve@android.com>
 <1272667021-21312-3-git-send-email-arve@android.com>
 <1272667021-21312-4-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272667021-21312-4-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> If a suspend_blocker is active, suspend will fail anyway. Since
> try_to_freeze_tasks can take up to 20 seconds to complete or fail, aborting
> as soon as someone blocks suspend (e.g. from an interrupt handler) improves
> the worst case wakeup latency.
> 
> On an older kernel where task freezing could fail for processes attached
> to a debugger, this fixed a problem where the device sometimes hung for
> 20 seconds before the screen turned on.
> 
> Signed-off-by: Arve Hj??nnev??g <arve@android.com>

I acked this one before, please preserve such tags.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
