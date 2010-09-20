Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0ITUp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:45:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53465 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab0ITUpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:45:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C97C7EC.5070907@s5r6.in-berlin.de>
Date: Mon, 20 Sep 2010 22:45:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #17752] 2.6.36-rc3: inconsistent lock state (iprune_sem,
 shrink_icache_memory)
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera> <Wn2eLj_6KZG.A._MH.jE7lMB@chimera>
In-Reply-To: <Wn2eLj_6KZG.A._MH.jE7lMB@chimera>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17752
> Subject		: 2.6.36-rc3: inconsistent lock state (iprune_sem, shrink_icache_memory)
> Submitter	: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Date		: 2010-09-01 6:37 (20 days old)
> Message-ID	: <tkrat.ed8eda6bc8ffe64e@s5r6.in-berlin.de>
> References	: http://marc.info/?l=linux-kernel&m=128332308528119&w=2

I think this should not be marked as a regression.  See the older reports of
very similar issues (in my LKML mail from September 3, logged in bugzilla in
comment #1)
	http://lkml.org/lkml/2010/1/15/76	(2.6.33-rc, xfs involved)
	http://lkml.org/lkml/2010/1/18/108	(2.6.32.y, ntfs involved)
and hch's analysis in the first of these two threads
	http://lkml.org/lkml/2010/1/19/267	(several filesystems and
						 other code paths)
So, unless my trace was a code path that only newly acquired that oldproblem
of other code paths, this is an older issue.  Alas this is not obvious to me
at least from the log that I got.

I did not have lockdep enabled on the machine which delivered the log during
the last few months or so; I just remembered to re-enable it at the occasion
of switching to 2.6.36-rc.
-- 
Stefan Richter
-=====-==-=- =--= =-=--
http://arcgraph.de/sr/
