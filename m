Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0EJJwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:52:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42354 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756203Ab0EJJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:52:13 -0400
Date: Mon, 10 May 2010 10:52:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/3] power/ds2760_battery: make charge_now and
 charge_full_design writeable
Message-ID: <20100510095211.GC31804@rakim.wolfsonmicro.main>
References: <1273254733-7010-1-git-send-email-daniel@caiaq.de>
 <1273254733-7010-2-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273254733-7010-2-git-send-email-daniel@caiaq.de>
X-Cookie: There's no time like the pleasant.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 07:52:12PM +0200, Daniel Mack wrote:
> For userspace tools and daemons, it might be necessary to adjust
> the charge_now and charge_full_design properties of the ds2760 battery
> monitor, for example for unavoidable corrections due to aging batteries.

Changing charge_full_design seems really odd - I'd really expect that to
be something which is constant throughout the lifetime of the system.  A
separate property showing the degraded capacity would be a bit less
surprising.
