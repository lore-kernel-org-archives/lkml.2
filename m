Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1HOPjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:39:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45002 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753816Ab1HOPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:39:17 -0400
Date: Tue, 16 Aug 2011 00:39:07 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH 2/3] regulator: tps65910: fix list_voltage for VDD1 and
 VDD2
Message-ID: <20110815153903.GA13172@opensource.wolfsonmicro.com>
References: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
 <1313405127-2724-2-git-send-email-jhovold@gmail.com>
 <20110815130910.GD3927@opensource.wolfsonmicro.com>
 <20110815142948.GB4189@localhost>
 <20110815144910.GA29685@opensource.wolfsonmicro.com>
 <20110815151253.GC4189@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815151253.GC4189@localhost>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 05:12:53PM +0200, Johan Hovold wrote:
> On Mon, Aug 15, 2011 at 11:49:13PM +0900, Mark Brown wrote:

> > You've got a bunch of missing break statements introduced by the same
> > commit in the same driver causing the same runtime issue...

> Well, the first bug prevents any device from being used at all (as probe
> always fails). The second bug makes list_voltage return the wrong value
> for two regulators.

> I simply prefer fixing them separately as it will be more clear from the
> changelog what behaviours are being fixed -- especially as they are
> marked for stable.

As a reviewer I did a double take as I wasn't immediately sure if this
was actually a different patch or not.
