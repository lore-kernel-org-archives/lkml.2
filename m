Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0CRO2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:28:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47725 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0CRO2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:28:48 -0400
MIME-Version: 1.0
In-Reply-To: <fa686aa41003111311w2a2c2707yddfe90c953b92be@mail.gmail.com>
References: <fa686aa41003111311w2a2c2707yddfe90c953b92be@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 18 Mar 2010 08:28:27 -0600
X-Google-Sender-Auth: 3611daa87f2b9388
Message-ID: <fa686aa41003180728r4867fedei67c664815679f542@mail.gmail.com>
Subject: [git pull updated] driver bug fixes and mpc5200 defconfig updates
To: linuxppc-dev@lists.ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Ellis <scott@jumpnowtek.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,  I've updated my merge branch to add a build fix (mpc52xx)
and an OF regression (fix comparison...).  Please pull.

Thanks,
g.

The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge

David Miller (1):
      uartlite: Fix build on sparc.

Grant Likely (3):
      powerpc/52xx: update defconfigs
      of: Fix comparison of "compatible" properties
      powerpc/5200: Build fix for mpc52xx watchdog timer code

Scott Ellis (2):
      spi/omap2_mcspi: fix NULL pointer dereference
      spi/omap2_mcspi: Use transaction speed if provided

 arch/powerpc/configs/52xx/cm5200_defconfig    |   24 ++--
 arch/powerpc/configs/52xx/lite5200b_defconfig |   28 +++--
 arch/powerpc/configs/52xx/motionpro_defconfig |   25 +++--
 arch/powerpc/configs/52xx/pcm030_defconfig    |   27 +++---
 arch/powerpc/configs/52xx/tqm5200_defconfig   |   28 +++---
 arch/powerpc/configs/mpc5200_defconfig        |  134 ++++++++++++++++---------
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c     |    6 +-
 drivers/serial/uartlite.c                     |   10 +-
 drivers/spi/omap2_mcspi.c                     |   18 ++-
 include/linux/of.h                            |    2 +-
 10 files changed, 183 insertions(+), 119 deletions(-)


On Thu, Mar 11, 2010 at 3:11 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Hi Linus,
>
> Here are some driver bug fixes, and the requisite powerpc-mpc5200
> defconfig updates.  The defconfig updates would normally go through
> Ben's tree, but since that is the only change I have that would go
> through his tree I'm hoping that it is okay to have it here.
>
> Cheers,
> g.
>
> The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
>  Linus Torvalds (1):
>        Linux 2.6.34-rc1
>
> are available in the git repository at:
>
>  git://git.secretlab.ca/git/linux-2.6 merge
>
> David Miller (1):
>      uartlite: Fix build on sparc.
>
> Grant Likely (1):
>      powerpc/52xx: update defconfigs
>
> Scott Ellis (2):
>      spi/omap2_mcspi: fix NULL pointer dereference
>      spi/omap2_mcspi: Use transaction speed if provided
>
>  arch/powerpc/configs/52xx/cm5200_defconfig    |   24 ++--
>  arch/powerpc/configs/52xx/lite5200b_defconfig |   28 +++--
>  arch/powerpc/configs/52xx/motionpro_defconfig |   25 +++--
>  arch/powerpc/configs/52xx/pcm030_defconfig    |   27 +++---
>  arch/powerpc/configs/52xx/tqm5200_defconfig   |   28 +++---
>  arch/powerpc/configs/mpc5200_defconfig        |  134 ++++++++++++++++---------
>  drivers/serial/uartlite.c                     |   10 +-
>  drivers/spi/omap2_mcspi.c                     |   18 ++-
>  8 files changed, 177 insertions(+), 117 deletions(-)
>
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
