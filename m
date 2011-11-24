Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1KXKPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:15:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49451 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1KXKPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:15:03 -0500
Date: Thu, 24 Nov 2011 11:15:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, len.brown@intel.com, rdunlap@xenotime.net, tj@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM/Hibernation: Fix the early termination of test modes
Message-ID: <20111124101501.GA3506@elf.ucw.cz>
References: <20111117211537.31044.80826.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117211537.31044.80826.stgit@srivatsabhat.in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2011-11-18 02:45:44, Srivatsa S. Bhat wrote:
> Commit 2aede851ddf08666f68ffc17be446420e9d2a056
> (PM / Hibernate: Freeze kernel threads after preallocating memory)
> postponed the freezing of kernel threads to after preallocating memory
> for hibernation. But while doing that, the hibernation test TEST_FREEZER
> and the test mode HIBERNATION_TESTPROC were not moved accordingly.
> 
> As a result, when using these test modes, it only goes upto the freezing of
> userspace and exits, when in fact it should go till the complete end of task
> freezing stage, namely the freezing of kernel threads as well.
> 
> So, move these points of exit to appropriate places so that freezing of
> kernel threads is also tested while using these test harnesses. And while at
> it, add some documentation about these test modes.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

ACK.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
