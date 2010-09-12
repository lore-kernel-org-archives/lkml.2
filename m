Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0ILQRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 12:17:34 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:52726 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0ILQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 12:17:33 -0400
Date: Sun, 12 Sep 2010 17:17:31 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Corentin Chary <corentincj@iksaif.net>
Subject: Re: EeePC 900 reboots/hangs when using using perf -a -f -g
Message-ID: <20100912161730.GA30698@sucs.org>
References: <20100912102854.GA7359@sucs.org> <1284289027.2251.95.camel@laptop> <20100912112105.GA28420@sucs.org> <20100912130637.GB5342@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912130637.GB5342@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 03:06:39PM +0200, Frederic Weisbecker wrote:
> 
> Testing with a software event like page faults will test if it's related
> to hardware events only or some of them.
> For example if it doesn't happen in fault events, then let's try with some
> others, just to see if we can narrow down to some particular events.

OK.

> If it happens on faults it will be easier to debug because software events
> don't happen in NMI (at least not the faults), so enabling RCU stalls checks
> there will probably success to trigger a backtrace. Perhaps you can profile
> only one CPU for that (-C 1, eeepc 900 are SMT, right?), so that there is
> a free CPU to notice the stall and trigger the backtrace through remote NMIs.

An EeePC has only one CPU (so it's strictly UP only). 

-- 
Sitsofe | http://sucs.org/~sits/
