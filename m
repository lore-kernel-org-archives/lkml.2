Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0DLUU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:20:57 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45664 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752614Ab0DLUUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:20:55 -0400
Date: Mon, 12 Apr 2010 22:20:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, peterz@infradead.org,
       mingo@elte.hu
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Message-ID: <20100412202047.GD2305@elf.ucw.cz>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I am resubmitting this patch because I believe that the discussion
> has shown this to be an acceptable solution.  I have fixed the 32 bit
> build errors, but other than that change, the code is the same as
> Roland's V3 patch.
> 
> From: Roland Dreier <rolandd@cisco.com>
> 
> As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
> and follow-up messages, libraries using RDMA would like to track
> precisely when application code changes memory mapping via free(),
> munmap(), etc.  Current pure-userspace solutions using malloc hooks
> and other tricks are not robust, and the feeling among experts is that
> the issue is unfixable without kernel help.

I do not know. I still believe that this does not belong in the
kernel; application should not need to trace itself to know what it does.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
