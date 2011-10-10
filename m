Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1JJQZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:25:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57807 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab1JJQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:25:10 -0400
Date: Mon, 10 Oct 2011 17:25:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] regulator: twl: Remove hardcoded board
 constraints from driver
Message-ID: <20111010162507.GF3607@opensource.wolfsonmicro.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-2-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318263578-7407-2-git-send-email-rnayak@ti.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 09:49:34PM +0530, Rajendra Nayak wrote:
> Remove the hardcoded .valid_modes_mask and .valid_ops_mask for
> each regulator from the twl driver and let the boards pass it.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Please update this changelog - as I said in reply to your previous
posting this isn't actually hardcoding anything, it's dropping things
from the constraints which the hardware doesn't support.
