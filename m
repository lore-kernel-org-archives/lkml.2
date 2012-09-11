Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab2IKVHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:07:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11779 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab2IKVHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:07:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="235486651"
Date: Tue, 11 Sep 2012 14:07:26 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Chris Ball <cjb@laptop.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 05/16] ARM: msm: move platform_data definitions
Message-ID: <20120911210726.GA17002@codeaurora.org>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347368390-31252-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 02:59:39PM +0200, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the msm include directories
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: linux-arm-msm@vger.kernel.org
> ---
>  arch/arm/mach-msm/board-qsd8x50.c                                    |    2 +-
>  arch/arm/mach-msm/board-trout-mmc.c                                  |    2 +-
>  arch/arm/mach-msm/board-trout-panel.c                                |    2 +-
>  arch/arm/mach-msm/devices-msm7x00.c                                  |    2 +-
>  arch/arm/mach-msm/devices-msm7x30.c                                  |    2 +-
>  arch/arm/mach-msm/devices-qsd8x50.c                                  |    2 +-
>  arch/arm/mach-msm/include/mach/board.h                               |    2 +-
>  drivers/mmc/host/msm_sdcc.c                                          |    2 +-
>  drivers/video/msm/mddi.c                                             |    2 +-
>  drivers/video/msm/mddi_client_dummy.c                                |    2 +-
>  drivers/video/msm/mddi_client_nt35399.c                              |    2 +-
>  drivers/video/msm/mddi_client_toshiba.c                              |    2 +-
>  drivers/video/msm/mdp.c                                              |    2 +-
>  drivers/video/msm/mdp_hw.h                                           |    2 +-
>  drivers/video/msm/mdp_ppp.c                                          |    2 +-
>  drivers/video/msm/msm_fb.c                                           |    2 +-
>  .../include/mach/mmc.h => include/linux/platform_data/mmc-msm_sdcc.h |    0
>  .../mach/msm_fb.h => include/linux/platform_data/video-msm_fb.h      |    0
>  18 files changed, 16 insertions(+), 16 deletions(-)
>  rename arch/arm/mach-msm/include/mach/mmc.h => include/linux/platform_data/mmc-msm_sdcc.h (100%)
>  rename arch/arm/mach-msm/include/mach/msm_fb.h => include/linux/platform_data/video-msm_fb.h (100%)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
