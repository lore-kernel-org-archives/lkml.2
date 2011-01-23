Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1AWKzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 05:55:55 -0500
Received: from trent.utfs.org ([194.246.123.103]:52752 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1AWKzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 05:55:54 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jan 2011 05:55:54 EST
Date: Sun, 23 Jan 2011 02:50:08 -0800 (PST)
From: Christian Kujau <christian@nerdbynature.de>
To: Michael Witten <mfwitten@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 'autogroup' sched code KILLING responsiveness
In-Reply-To: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
Message-ID: <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 at 10:20, Michael Witten wrote:
> With that code in place, a resource-intensive activity (such as
> compiling the Linux kernel) causes my computer to become
> unresponsive for many seconds at a time; the entire screen
> does not refresh, typed keys are dropped or are handled very
> late, etc (even in Linux's plain virtual consoles).

Unfortunately, I'd like to add a "me too". 2.6.38-rc1 behaves fine, but 
with CONFIG_SCHED_AUTOGROUP=y and doing I/O and CPU intensive work (git 
prune/git repack on a Linux git tree), system load goes up to ~13 and 
becomes unresponse for some time too. This even happens when I start the 
jobs with nice -n10.

Without CONFIG_SCHED_AUTOGROUP enabled and doing the same work,
systemload goes up to 1 or maybe 2.

I'm on UP as well (PowerPC G4), disabling CONFIG_SCHED_AUTOGROUP helps 
here too.

Thanks,
Christian.
-- 
BOFH excuse #274:

It was OK before you touched it.
