Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1J0JIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:08:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33696 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732Ab1J0JIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:08:49 -0400
Date: Thu, 27 Oct 2011 10:08:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com
Subject: Re: [PATCH v3 0/4] Device tree support for regulators
Message-ID: <20111027090847.GC6641@opensource.wolfsonmicro.com>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319702185-16108-1-git-send-email-rnayak@ti.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:26:21PM +0530, Rajendra Nayak wrote:

> v3 is based on the latest devicetree/next and is tested
> (with twl adaptaions, which will be posted seperately)
> on the OMAP4 panda and OMAP4 sdp boards.

Looking at the device bindings I notice that these bindings loose the
ability to assign a descriptive name to regulator outputs.  This is
really useful for making it easy to tie the code and the schematics
together - you can make the runing system use the same name as the
schematic.
