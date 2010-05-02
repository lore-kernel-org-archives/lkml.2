Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0EBHGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 03:06:17 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43452 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752504Ab0EBHGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 03:06:15 -0400
Date: Sun, 2 May 2010 09:05:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj??nnev??g <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
Message-ID: <20100502070555.GE1790@ucw.cz>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <1272667021-21312-2-git-send-email-arve@android.com>
 <1272667021-21312-3-git-send-email-arve@android.com>
 <1272667021-21312-4-git-send-email-arve@android.com>
 <1272667021-21312-5-git-send-email-arve@android.com>
 <1272667021-21312-6-git-send-email-arve@android.com>
 <1272667021-21312-7-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272667021-21312-7-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-04-30 15:36:59, Arve Hj??nnev??g wrote:
> Allow work to be queued that will block suspend while it is pending
> or executing. To get the same functionality in the calling code often
> requires a separate suspend_blocker for pending and executing work, or
> additional state and locking. This implementation does add additional
> state and locking, but this can be removed later if we add support for
> suspend blocking work to the core workqueue code.
> 
> Signed-off-by: Arve Hj??nnev??g <arve@android.com>

Looks ok.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
