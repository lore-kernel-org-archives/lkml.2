Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1JYHLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:11:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50640 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab1JYHLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:11:43 -0400
Date: Tue, 25 Oct 2011 09:11:40 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Rajendra Nayak <rnayak@ti.com>,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111025071140.GC2919@opensource.wolfsonmicro.com>
References: <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <20111024092411.GE8708@ponder.secretlab.ca>
 <20111024130429.GD1755@S2100-06.ap.freescale.net>
 <20111024130636.GB26033@opensource.wolfsonmicro.com>
 <20111024134025.GE1755@S2100-06.ap.freescale.net>
 <20111024134930.GD26033@opensource.wolfsonmicro.com>
 <20111024144716.GG1755@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024144716.GG1755@S2100-06.ap.freescale.net>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 10:47:17PM +0800, Shawn Guo wrote:
> On Mon, Oct 24, 2011 at 03:49:30PM +0200, Mark Brown wrote:

> > Might be best to just
> > search within dev and get drivers to pass the "real" device in when
> > registering the regulator rather than the virtual device.

> It should also work, but it will also change the API slightly for
> non-dt users.  I'm not sure it's something we want.

I don't think that's an issue at all.
