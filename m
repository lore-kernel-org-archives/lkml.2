Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2ATMv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 07:51:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52112 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419Ab2ATMvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:51:55 -0500
Date: Fri, 20 Jan 2012 12:51:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] mfd: tps65910: Add wakeup support
Message-ID: <20120120125152.GE18297@opensource.wolfsonmicro.com>
References: <1327057770-6688-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327057770-6688-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:39:30PM +0530, Laxman Dewangan wrote:
> Adding wakeup support for PMIC device 65910. This can be
> selected through the board specific platform data.

> The wakeup should enabled if PMIC need to be configure for
> waking up system through RTC or ONKEY.

Why the platform data?  The power management infrastructure provides
control of this already.
