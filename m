Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554Ab0KQNcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:32:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40505 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933939Ab0KQNcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:32:32 -0500
Date: Wed, 17 Nov 2010 13:32:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regulator: Move lp3971 regulator driver to
	subsys_initcall()
Message-ID: <20101117133231.GK3338@sirena.org.uk>
References: <1289962844.8233.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289962844.8233.2.camel@mola>
X-Cookie: Who messed with my anti-paranoia shot?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 11:00:44AM +0800, Axel Lin wrote:
> Regulators need to be available early in init in order to allow them
> to be available for consumers when requested.
> 
> Other regulator drivers are already moved to subsys_initcall(),
> looks like only lp3971 is missing.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
