Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1J0MVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:21:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59553 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab1J0MVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:21:01 -0400
Date: Thu, 27 Oct 2011 13:20:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com
Subject: Re: [PATCH v3 4/4] regulator: map consumer regulator based on
 device tree
Message-ID: <20111027122054.GC10089@sirena.org.uk>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <1319702185-16108-5-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319702185-16108-5-git-send-email-rnayak@ti.com>
X-Cookie: When does later become never?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:26:25PM +0530, Rajendra Nayak wrote:
> Device nodes in DT can associate themselves with one or more
> regulators/supply by providing a list of phandles (to regulator nodes)
> and corresponding supply names.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
