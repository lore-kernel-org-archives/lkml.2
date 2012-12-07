Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab2LGBjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:39:13 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:55401 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab2LGBjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:39:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1212070057240.22351@utopia.booyaka.com>
References: <20121204154203.f0e7e87d1ae99e5c528434f8@canb.auug.org.au>
	<20121204110655.GE18368@8bytes.org>
	<CAK=WgbYDKN1deDTw3KvymvhoE1h_apX2E8zK=cDbu68+Gwcayw@mail.gmail.com>
	<CAJ6Av5OBhpsSRiZNOa1a65yMT04Evaja6j8qPBiSuVM1DPdB1Q@mail.gmail.com>
	<alpine.DEB.2.00.1212070057240.22351@utopia.booyaka.com>
Date: Thu, 6 Dec 2012 19:39:11 -0600
Message-ID: <CAJ6Av5NqFtr9g+oB0s2ncDSvGuriqPW6iHvpmKH_+58hF5q1Pw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the iommu tree
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@ti.com>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Dec 6, 2012 at 6:59 PM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi Omar,
>
> On Thu, 6 Dec 2012, Omar Ramirez Luna wrote:
>
>> I have checked next-20121206, it's OK to delete that file as the patch
>> from Paul is doing that for common clock framework migration; now the
>> only missing hunk from my original patch should apply to
>> arch/arm/mach-omap2/cclock44xx_data.c which is the file that now has
>> ipu_fck and dsp_fck (unused) clocks, I can send a patch to remove them
>> through linux-omap tree.
>
> OK, will you add the mach-omap2/omap_hwmod_44xx_data.c changes in the same
> patch?

I was planning to wait until linux-omap had the changes from iommu
tree (probably at rc1), if the merge conflict resulted in
arch/arm/mach-omap2/cclock44xx_data.c still having ipu and dsp clocks,
in this case the hwmod data changes wouldn't be needed in the patch.

Cheers,

Omar
