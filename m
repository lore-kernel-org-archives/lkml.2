Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1J0MSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:18:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59468 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1J0MSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:18:12 -0400
Date: Thu, 27 Oct 2011 13:18:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com
Subject: Re: [PATCH v3 2/4] regulator: adapt fixed regulator driver to dt
Message-ID: <20111027121800.GA10089@sirena.org.uk>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <1319702185-16108-3-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319702185-16108-3-git-send-email-rnayak@ti.com>
X-Cookie: When does later become never?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:26:23PM +0530, Rajendra Nayak wrote:
> The fixed regulator driver uses of_get_fixed_voltage_config()
> to extract fixed_voltage_config structure contents from device tree.
> 
> Also add documenation for additional bindings for fixed
> regulators that can be passed through dt.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
