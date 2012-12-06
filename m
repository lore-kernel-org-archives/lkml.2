Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2LFXQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 18:16:06 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:49477 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2LFXQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 18:16:04 -0500
X-Greylist: delayed 1317 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 18:16:04 EST
MIME-Version: 1.0
In-Reply-To: <CAK=WgbYDKN1deDTw3KvymvhoE1h_apX2E8zK=cDbu68+Gwcayw@mail.gmail.com>
References: <20121204154203.f0e7e87d1ae99e5c528434f8@canb.auug.org.au>
	<20121204110655.GE18368@8bytes.org>
	<CAK=WgbYDKN1deDTw3KvymvhoE1h_apX2E8zK=cDbu68+Gwcayw@mail.gmail.com>
Date: Thu, 6 Dec 2012 16:54:04 -0600
Message-ID: <CAJ6Av5OBhpsSRiZNOa1a65yMT04Evaja6j8qPBiSuVM1DPdB1Q@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the iommu tree
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Joerg Roedel <joro@8bytes.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Mike Turquette <mturquette@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Tue, Dec 4, 2012 at 5:10 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Dec 4, 2012 at 1:06 PM, Joerg Roedel <joro@8bytes.org> wrote:
>> On Tue, Dec 04, 2012 at 03:42:03PM +1100, Stephen Rothwell wrote:
>>> Today's linux-next merge of the arm-soc tree got a conflict in
>>> arch/arm/mach-omap2/clock44xx_data.c between commit 298ea44f211d ("ARM:
>>> OMAP4: hwmod data: ipu and dsp to use parent clocks instead of leaf
>>> clocks") from the iommu tree and commit 13a5b6228679 ("ARM: OMAP44xx:
>>> clock: drop obsolete clock data") from the arm-soc tree.
>>>
>>> I just deleted the file as the latter did and can carry the fix as
>>> necessary (no action is required).
>>
>> Ohad, Omar, any comment on this?
>
> I'd prefer Omar or Paul to have a look here. Looping in Tony as well.

I have checked next-20121206, it's OK to delete that file as the patch
from Paul is doing that for common clock framework migration; now the
only missing hunk from my original patch should apply to
arch/arm/mach-omap2/cclock44xx_data.c which is the file that now has
ipu_fck and dsp_fck (unused) clocks, I can send a patch to remove them
through linux-omap tree.

Cheers,

Omar
