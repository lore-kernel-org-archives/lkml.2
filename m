Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab2LGBkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:40:24 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:34624 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab2LGBkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:40:22 -0500
Date: Fri, 7 Dec 2012 01:40:21 +0000 (UTC)
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
In-Reply-To: <CAJ6Av5NqFtr9g+oB0s2ncDSvGuriqPW6iHvpmKH_+58hF5q1Pw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1212070140080.22351@utopia.booyaka.com>
References: <20121204154203.f0e7e87d1ae99e5c528434f8@canb.auug.org.au> <20121204110655.GE18368@8bytes.org> <CAK=WgbYDKN1deDTw3KvymvhoE1h_apX2E8zK=cDbu68+Gwcayw@mail.gmail.com> <CAJ6Av5OBhpsSRiZNOa1a65yMT04Evaja6j8qPBiSuVM1DPdB1Q@mail.gmail.com>
 <alpine.DEB.2.00.1212070057240.22351@utopia.booyaka.com> <CAJ6Av5NqFtr9g+oB0s2ncDSvGuriqPW6iHvpmKH_+58hF5q1Pw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2012, Omar Ramirez Luna wrote:

> I was planning to wait until linux-omap had the changes from iommu
> tree (probably at rc1), if the merge conflict resulted in
> arch/arm/mach-omap2/cclock44xx_data.c still having ipu and dsp clocks,
> in this case the hwmod data changes wouldn't be needed in the patch.

OK makes sense.

- Paul
