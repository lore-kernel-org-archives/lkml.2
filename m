Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab2EBDDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:03:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51946 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab2EBDDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:03:49 -0400
Date: Wed, 2 May 2012 11:03:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v2 0/3] Add imx cpuidle
Message-ID: <20120502030337.GS2194@S2101-09.ap.freescale.net>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 09:12:37PM -0500, Robert Lee wrote:
> Add common imx cpuidle initialization functionality and add a i.MX5 and i.MX6Q
> platform cpuidle implementation.
> 
> Based on v3.4-rc5 plus recently submitted device tree late_initcall patch:

Just to clarify, this is not a device tree late_initcall but a machine
specific late_initcall time hook.  It has nothing to do with device
tree.

Regards,
Shawn

>  http://www.spinics.net/lists/arm-kernel/msg171620.html
> 
> Changes since v1:
>  * Removed some unnecessary  spaces
>  * Added return value for an error message
>  * Reworked init scheme to use device tree late_initcall.
>  * Moved imx6q and imx5 cpuidle functionality to existing files.
> 
> Robert Lee (3):
>   ARM: imx: Add common imx cpuidle init functionality.
>   ARM: imx: Add imx5 cpuidle driver
>   ARM: imx: Add imx6q cpuidle driver
> 
>  arch/arm/mach-imx/cpuidle-imx6q.c        |   33 ++++++++++++
>  arch/arm/mach-imx/mach-imx6q.c           |   18 +++++++
>  arch/arm/mach-imx/mm-imx5.c              |   42 ++++++++++++++--
>  arch/arm/plat-mxc/Makefile               |    1 +
>  arch/arm/plat-mxc/cpuidle.c              |   80 ++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/cpuidle.h |   22 ++++++++
>  6 files changed, 193 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/mach-imx/cpuidle-imx6q.c
>  create mode 100644 arch/arm/plat-mxc/cpuidle.c
>  create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h
> 
> -- 
> 1.7.10
> 
