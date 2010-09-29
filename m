Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab0I2EUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 00:20:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36267 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0I2EUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 00:20:18 -0400
Date: Wed, 29 Sep 2010 05:20:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, rmk@arm.linux.org.uk, kgene.kim@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 1/2] MAINTAINERS: Add Samsung Mobile Board maintainers
Message-ID: <20100929042015.GA21248@sirena.org.uk>
References: <20100929025200.GA7998@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929025200.GA7998@july>
X-Cookie: Support wildlife -- vote for an orgy.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 11:52:00AM +0900, Kyungmin Park wrote:

> +ARM/S5PC110 AQUILA,GONI MACHINE SUPPORT
> +M:	Kyungmin Park <kyungmin.park@samsung.com>
> +M:	Marek Szyprowski <m.szyprowski@samsung.com>
> +L:	linux-arm-kernel@lists.infradead.org
> +S:	Maintained
> +F:	arch/arm/mach-s5pv210/mach-aquila.c
> +F:	arch/arm/mach-s5pv210/mach-goni.c

There's also sound/soc/s3c24xx/{aquilla,goni}_wm8994.c though with
Jassi's forthcoming directory move that path should need updating very
soon so perhaps as well not to bother just yet.
