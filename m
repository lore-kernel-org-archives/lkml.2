Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423407Ab2LGA7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:59:14 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:34434 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423393Ab2LGA7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:59:11 -0500
Date: Fri, 7 Dec 2012 00:59:10 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the iommu
 tree
In-Reply-To: <CAJ6Av5OBhpsSRiZNOa1a65yMT04Evaja6j8qPBiSuVM1DPdB1Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1212070057240.22351@utopia.booyaka.com>
References: <20121204154203.f0e7e87d1ae99e5c528434f8@canb.auug.org.au> <20121204110655.GE18368@8bytes.org> <CAK=WgbYDKN1deDTw3KvymvhoE1h_apX2E8zK=cDbu68+Gwcayw@mail.gmail.com> <CAJ6Av5OBhpsSRiZNOa1a65yMT04Evaja6j8qPBiSuVM1DPdB1Q@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Omar,

On Thu, 6 Dec 2012, Omar Ramirez Luna wrote:

> I have checked next-20121206, it's OK to delete that file as the patch
> from Paul is doing that for common clock framework migration; now the
> only missing hunk from my original patch should apply to
> arch/arm/mach-omap2/cclock44xx_data.c which is the file that now has
> ipu_fck and dsp_fck (unused) clocks, I can send a patch to remove them
> through linux-omap tree.

OK, will you add the mach-omap2/omap_hwmod_44xx_data.c changes in the same 
patch?


- Paul
