Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab2LCS2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:28:52 -0500
Received: from science.horizon.com ([71.41.210.146]:27333 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750792Ab2LCS2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:28:51 -0500
Date: 3 Dec 2012 13:28:48 -0500
Message-ID: <20121203182848.5536.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mgorman@suse.de
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Cc: dave@linux.vnet.ibm.com, hannes@cmpxchg.org, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com
In-Reply-To: <20121129145414.9415.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Almost three days, when it wouldn't live overnight before.
> As promised, I'm declaring victory.
> 
> The patch that worked (on top of -rc7) was Johannes Weiner's
> "mm: vmscan: fix endless loop in kswapd balancing"
> that added the zone_balanced() function to mm/vmscan.c:2400.
> 
> Thank you all very much!

Further update, uptime is now 1 week with no more problems.

Just checked dmesg; no complaints.  And kswapd0 is showing 0:09.08 of
CPU time for the week, more than cron but less than init.

Tested-by: George Spelvin <linux@horizon.com>
