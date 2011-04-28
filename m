Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab1D1UzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:55:19 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57674 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab1D1UzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:55:16 -0400
Subject: Re: [PATCH] clocksource: sh_cmt: __clocksource_updatefreq_hz()
 update
From: john stultz <johnstul@us.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, simon@horms.net,
        linux-sh@vger.kernel.org
In-Reply-To: <20110425133211.3957.30006.sendpatchset@t400s>
References: <20110425133211.3957.30006.sendpatchset@t400s>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 13:55:09 -0700
Message-ID: <1304024109.2971.104.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 22:32 +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> This patch updates the clocksource part of the CMT driver
> to make use of the __clocksource_updatefreq_hz() function.
> 
> Without this patch the old code uses clocksource_register()
> together with a hack that assumes a never changing clock rate
> (see clk_enable(), clk_get_rate() and clk_disable()).
> 
> The patch uses clocksource_register_hz() with 1 Hz as initial
> value, then lets the ->enable() callback update the value
> with __clocksource_updatefreq_hz() once the struct clk has
> been enabled and the frequency is stable.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: John Stultz <johnstul@us.ibm.com>

If these don't get picked up for 2.6.40, I'll queue them myself.

thanks
-john

