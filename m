Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1I2JaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:30:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38054 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab1I2JaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:30:08 -0400
Date: Thu, 29 Sep 2011 10:29:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 2/3] arm/tegra: add support for ventana pinmuxing
Message-ID: <20110929092951.GE23944@n2100.arm.linux.org.uk>
References: <1317248978-10829-1-git-send-email-pdeschrijver@nvidia.com> <1317248978-10829-3-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317248978-10829-3-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 01:29:35AM +0300, Peter De Schrijver wrote:
> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> index f11b910..91a07e1 100644
> --- a/arch/arm/mach-tegra/Makefile
> +++ b/arch/arm/mach-tegra/Makefile
> @@ -31,6 +31,7 @@ obj-${CONFIG_MACH_SEABOARD}             += board-seaboard-pinmux.o
>  
>  obj-${CONFIG_MACH_TEGRA_DT}             += board-dt.o
>  obj-${CONFIG_MACH_TEGRA_DT}             += board-harmony-pinmux.o
> +obj-${CONFIG_MACH_TEGRA_DT}             += board-seaboard-pinmux.o

Since when did Tegra start using braces instead of parens in its Makefile?
I note some of Tegra's makefile is using braces and some of it parens.
What's the reason for this alternative style to the rest of kbuild?
