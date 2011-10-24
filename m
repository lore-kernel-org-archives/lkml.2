Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1JXHey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:34:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37481 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab1JXHex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:34:53 -0400
Date: Mon, 24 Oct 2011 09:34:44 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024073443.GA2884@opensource.wolfsonmicro.com>
References: <20111018132032.GD30703@S2100-06.ap.freescale.net>
 <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <4EA13053.7080306@ti.com>
 <20111021115809.GB337@S2100-06.ap.freescale.net>
 <4EA4FF6B.2080906@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA4FF6B.2080906@ti.com>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:32:19AM +0530, Rajendra Nayak wrote:
> On Friday 21 October 2011 05:28 PM, Shawn Guo wrote:

> >Driver name does not matter.  The key for this search to work is having
> >regulator's name (regulator_desc->name) match device tree node's name,
> >case ignored.

> Mark, whats your take on this? I am somehow not quite sure if we should
> have this limitation put in to match DT node names with whats in the
> driver structs (regulator_desc).

If we're matching the string in the regulator_desc I'd expect we're
going to run into trouble with systems that have two of the same type of
regulator in the system.  Is that the case?  Since my primary
development system is such a system I care deeply about them :)
