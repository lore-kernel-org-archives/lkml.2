Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1B1SzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:55:04 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43795 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1B1SzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:55:02 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6271"; a="77137643"
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH 2/2] msm: clock: Migrate to clkdev
In-Reply-To: <1298482662-27298-3-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Wed, 23 Feb 2011 09:37:42 -0800")
References: <1298482662-27298-1-git-send-email-sboyd@codeaurora.org>
	<1298482662-27298-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110228:sboyd@codeaurora.org::B9Khjv4HGj23v7ef:000000000000000000000000000000000000000001ywu
X-Hashcash: 1:20:110228:linux-arm-msm@vger.kernel.org::5E5+AsLvKPxats/w:000000000000000000000000000000001bdk
X-Hashcash: 1:20:110228:skannan@codeaurora.org::/joG/EEVKRiIMww7:0000000000000000000000000000000000000003RrN
X-Hashcash: 1:20:110228:linux-arm-kernel@lists.infradead.org::juYL/AKn5+yOB0Yr:00000000000000000000000003Y0F
X-Hashcash: 1:20:110228:linux-kernel@vger.kernel.org::5Muc7pw2rAldPQKd:0000000000000000000000000000000009Mw9
Date: Mon, 28 Feb 2011 10:55:00 -0800
Message-ID: <8yay6500z23.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23 2011, Stephen Boyd wrote:

> Migrating to clkdev has several advantages:
>
>  * Less code in mach-msm/clock.c
>
>  * A more robust clk_get() implementation
>
>  * clk_add_alias() support
>
>  * clk_get_sys() support
>
> In general, this will help board authors setup clock aliases and
> break the dependency on device pointers in the clock tables.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/Kconfig                        |    1 +
>  arch/arm/mach-msm/board-msm7x30.c       |    1 +
>  arch/arm/mach-msm/board-msm8960.c       |    1 +
>  arch/arm/mach-msm/board-qsd8x50.c       |    1 +
>  arch/arm/mach-msm/board-trout.c         |    1 +
>  arch/arm/mach-msm/clock-7x30.h          |   31 +++++++++++++-----------
>  arch/arm/mach-msm/clock-pcom.h          |   16 +++++++-----
>  arch/arm/mach-msm/clock.c               |   39 ++++++++-----------------------
>  arch/arm/mach-msm/clock.h               |    2 -
>  arch/arm/mach-msm/devices-msm7x00.c     |   32 ++++++++++++------------
>  arch/arm/mach-msm/devices-msm7x30.c     |    5 ++-
>  arch/arm/mach-msm/devices-qsd8x50.c     |   23 +++++++++--------
>  arch/arm/mach-msm/devices.h             |    8 ++++--
>  arch/arm/mach-msm/include/mach/board.h  |    4 +-
>  arch/arm/mach-msm/include/mach/clkdev.h |   19 +++++++++++++++
>  15 files changed, 98 insertions(+), 86 deletions(-)
>  create mode 100644 arch/arm/mach-msm/include/mach/clkdev.h

This doesn't seem to apply cleanly.  Do you mind resending this against
the msm for/next branch.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
