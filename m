Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1JXJji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:39:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41001 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966Ab1JXJjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:39:37 -0400
Date: Mon, 24 Oct 2011 11:39:27 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Shawn Guo <shawn.guo@freescale.com>, Rajendra Nayak <rnayak@ti.com>,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024093925.GB6148@opensource.wolfsonmicro.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111018132032.GD30703@S2100-06.ap.freescale.net>
 <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <20111024092411.GE8708@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024092411.GE8708@ponder.secretlab.ca>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:24:11AM +0200, Grant Likely wrote:

> To follow up from my earlier comment, this .dts structure looks fine
> and reasonable to me, and it would also be fine for the mc13892 driver
> to use for_each_child_of_node() to find all the children of the
> regulators node.  Even finding the 'regulators' node by name from the
> mc13892 driver is perfectly fine provided for_each_child_of_node is
> used to find it.  All of this is okay because it is under the umbrella
> of the "fsl,mc13892" binding.

Yes, a search of children of the device node that the driver is probing
off seems like a sensible approach.
