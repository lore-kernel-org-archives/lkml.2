Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab1EWFix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:38:53 -0400
Received: from linux-sh.org ([111.68.239.195]:57113 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab1EWFiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:38:51 -0400
Date: Mon, 23 May 2011 14:38:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] clocksource: sh_tmu: __clocksource_updatefreq_hz() update
Message-ID: <20110523053808.GG5206@linux-sh.org>
References: <20110425133837.4242.80952.sendpatchset@t400s> <1304024143.2971.106.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304024143.2971.106.camel@work-vm>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 01:55:43PM -0700, john stultz wrote:
> On Mon, 2011-04-25 at 22:38 +0900, Magnus Damm wrote:
> > From: Magnus Damm <damm@opensource.se>
> > 
> > This patch updates the clocksource part of the TMU driver
> > to make use of the __clocksource_updatefreq_hz() function.
> > 
> > Without this patch the old code uses clocksource_register()
> > together with a hack that assumes a never changing clock rate
> > (see clk_enable(), clk_get_rate() and clk_disable()).
> > 
> > The patch uses clocksource_register_hz() with 1 Hz as initial
> > value, then lets the ->enable() callback update the value
> > with __clocksource_updatefreq_hz() once the struct clk has
> > been enabled and the frequency is stable.
> > 
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> 
> Acked-by: John Stultz <johnstul@us.ibm.com>
> 
> If these don't get picked up for 2.6.40, I'll queue them myself.
> 
I've queued them all now, with your Acks, thanks.
