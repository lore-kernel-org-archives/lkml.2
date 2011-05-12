Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab1ELOYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:24:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56003 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1ELOYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:24:45 -0400
Date: Thu, 12 May 2011 15:24:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk
Subject: Re: [PATCH v2 1/4] MFD: TWL6025: add phoenix lite support to
	twl6030
Message-ID: <20110512142443.GA16218@sirena.org.uk>
References: <1305206878-18094-1-git-send-email-gg@slimlogic.co.uk> <1305206878-18094-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305206878-18094-2-git-send-email-gg@slimlogic.co.uk>
X-Cookie: Meester, do you vant to buy a duck?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 02:27:55PM +0100, Graeme Gregory wrote:
> Phoenix Lite is based on the twl6030 family of PMICs. It has mostly the
> same feature set of twl6030 but with small changes. The codec block has
> also been removed. It also has a new charger block and new features in
> its ADC block. VUSB handling also differs.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonicro.com>

> +	pdata->driver_data = (void *)features;
> +

You never need to cast to void, and doing needless casts can mask bugs.
