Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1HOOtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:49:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51901 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753952Ab1HOOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:49:22 -0400
Date: Mon, 15 Aug 2011 23:49:13 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH 2/3] regulator: tps65910: fix list_voltage for VDD1 and
 VDD2
Message-ID: <20110815144910.GA29685@opensource.wolfsonmicro.com>
References: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
 <1313405127-2724-2-git-send-email-jhovold@gmail.com>
 <20110815130910.GD3927@opensource.wolfsonmicro.com>
 <20110815142948.GB4189@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815142948.GB4189@localhost>
X-Cookie: You are number 6!  Who is number one?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 04:29:48PM +0200, Johan Hovold wrote:
> On Mon, Aug 15, 2011 at 10:09:13PM +0900, Mark Brown wrote:

> > Why is this a separate patch to the previous one?

> Because it fixes a different bug (although introduced by the same commit
> and the same kind of programming error).

You've got a bunch of missing break statements introduced by the same
commit in the same driver causing the same runtime issue...
