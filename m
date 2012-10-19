Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2JSBaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:30:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48966 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756880Ab2JSBap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:30:45 -0400
Date: Fri, 19 Oct 2012 02:30:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: rob.herring@calxeda.com, shawn.guo@linaro.org, kernel@pengutronix.de,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2 2/2] mfd: Kconfig: Let MFD_SYSCON select REGMAP
Message-ID: <20121019013043.GB2353@opensource.wolfsonmicro.com>
References: <1350605046-21358-1-git-send-email-festevam@gmail.com> <1350605046-21358-2-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350605046-21358-2-git-send-email-festevam@gmail.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 09:04:06PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Building multi_v7_defconfig for mx6 causes the following build error:

> Fix it by selecting REGMAP option.

No, this is silly - selecting MMIO ought to do the right thing.  There's
a patch queued for Linus which will resolve this.
