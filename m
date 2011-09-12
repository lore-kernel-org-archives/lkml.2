Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1ILSgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 14:36:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab1ILSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:36:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, Kevin Hilman <khilman@ti.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] arm-soc fixes for 3.1
Date: Mon, 12 Sep 2011 20:36:18 +0200
Message-ID: <5084296.Xkn34IkqZ4@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <201109121807.45377.arnd@arndb.de>
References: <201109121807.45377.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MGq5i+6uBnVSFhR4te5VTCvgfsy6YupudkX+RAjtLND
 MgVaIde6zQQdcnhtNaPvk8eU5ihfiA+YnRKeanKqX14OW+OGnN
 N7k0PQ7ua3/korl55B02qGGwHEJwFKnePmkXzhOteN6q+xLxU4
 O9hcfH4TOjaYlsViobnWamlmN49uwoUUFhu/agYMbm2RZ6G0Fb
 HsgejJCrCQp86jGqQ59/cx5ll2zMIeK4ob53gkVIutlXvNuo/d
 KZh950F4nES84zZeUgBsByvuJpEVoehNSDRygzyhofegQMf/nh
 K7xE4uIb6VuwodwT14R+38LAVxWXJkArGN4yqrqmWSMvDk4orq
 EpCu1UQ8mobDH1jpe6nU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 September 2011 18:07:45 Arnd Bergmann wrote:
> Hi Linus,
> 
> I've moved a copy of the arm-soc tree to git.linaro.org for now. Since
> g.k.o contains to be unavailable, that seemed to be the most reliable
> alternative for me.
> 
> The fixes for 3.1 that have come in during this time are for four platforms:
> cns3xxx, davinci, omap2+, and prima2. I have a large set of build fixes
> that I found myself during randconfig builds, but most of these have been
> around forever, so I'm waiting for the merge window with those. I'm trying
> to feed the actual build regressions through the individual maintainers,
> so a few of those might be still be coming.
> 
> The following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:
> 
>   Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)
> 
> are available in the git repository at:
>  git://git.linaro.org/people/arnd/arm-soc.git fixes

One of the patches I mentioned was actually acked already but I had forgotten
about it (sorry Kevin), so I've added it to the same branch.

If you haven't pulled already, you will get one more fix. Otherwise, I'll
send this one together with the next bunch.

	Arnd

---
The following changes since commit d035953e59ca8bb7ffc1023efba72438524457bb:

  Merge branch 'sirf/fixes' into fixes (2011-09-12 14:59:37 +0000)

are available in the git repository at:

  git+ssh://arndbergmann@git.linaro.org/home/arndbergmann/public_git/arm-soc.git fixes

Arnd Bergmann (1):
      Merge branch 'for_3.1/pm-fixes-2' of git://gitorious.org/khilman/linux-omap-pm into fixes

Kevin Hilman (1):
      OMAP: omap_device: fix !CONFIG_SUSPEND case in _noirq handlers

 arch/arm/plat-omap/omap_device.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

