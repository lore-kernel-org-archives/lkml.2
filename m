Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1JXJTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:19:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50010 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161Ab1JXJTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:19:33 -0400
Date: Mon, 24 Oct 2011 11:19:25 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Shawn Guo <shawn.guo@freescale.com>, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024091924.GA6148@opensource.wolfsonmicro.com>
References: <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <4EA13053.7080306@ti.com>
 <20111021115809.GB337@S2100-06.ap.freescale.net>
 <4EA4FF6B.2080906@ti.com>
 <20111024081706.GC8708@ponder.secretlab.ca>
 <4EA5279E.3000505@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA5279E.3000505@ti.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:23:50PM +0530, Rajendra Nayak wrote:

> How about the driver passing the of_node to be associated with the
> regulator, as part of regulator_desc, to the regulator core,
> instead of this complete DT search and the restriction of having
> to match DT node names with names in regulator_desc.

regulator_desc should be const so that we handle multiple instances of
the same device nicely.  We could pass the information in as an argument
I guess.
