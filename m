Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2GDCkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:40:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45067 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2GDCkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:40:43 -0400
Message-ID: <4FF3AD27.5070901@gmail.com>
Date: Tue, 03 Jul 2012 21:40:39 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [GIT PULL] DT fixes for 3.5
References: <4FDA9261.2070208@gmail.com>
In-Reply-To: <4FDA9261.2070208@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On 06/14/2012 08:39 PM, Rob Herring wrote:
> Grant,
> 
> Please pull. Mainly some documentation updates and 2 fixes:
> 
> - An export symbol fix for of_platform_populate from Stephen W.
> - A fix for the order compatible entries are matched to ensure the
> first compatible string is matched when there are multiple matches.
> 

As Grant is offline the next month or two, can you please pull these
fixes for device tree for 3.5.

Rob

> The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:
> 
>   Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)
> 
> are available in the git repository at:
> 
>   git://sources.calxeda.com/kernel/linux.git fixes-for-grant
> 
> for you to fetch changes up to 107a84e61cdd3406c842a0e4be7efffd3a05dba6:
> 
>   of: match by compatible property first (2012-06-14 20:29:40 -0500)
> 
> ----------------------------------------------------------------
> Fabio Estevam (5):
>       dt: fsl-imx-cspi.txt: Fix comment about GPIOs used for chip selects
>       dt: fsl-imx-esdhc.txt: Fix gpio number assignment
>       dt: fsl-mma8450.txt: Add missing 'reg' description
>       dt: fsl-fec.txt: Fix gpio number assignment
>       dt: mc13xxx.txt: Fix gpio number assignment
> 
> Stephen Warren (1):
>       of: export of_platform_populate()
> 
> Thierry Reding (2):
>       of: Add Avionic Design vendor prefix
>       of: match by compatible property first
> 
>  .../devicetree/bindings/input/fsl-mma8450.txt      |    1 +
>  Documentation/devicetree/bindings/mfd/mc13xxx.txt  |    4 +--
>  .../devicetree/bindings/mmc/fsl-imx-esdhc.txt      |    4 +--
>  Documentation/devicetree/bindings/net/fsl-fec.txt  |    2 +-
>  .../devicetree/bindings/spi/fsl-imx-cspi.txt       |    4 +--
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  drivers/of/base.c                                  |   30
> +++++++++++++++++---
>  drivers/of/platform.c                              |    1 +
>  8 files changed, 36 insertions(+), 11 deletions(-)
> 


