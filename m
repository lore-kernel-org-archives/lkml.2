Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2FEQOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:14:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51059 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2FEQOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:14:52 -0400
Message-ID: <4FCE3078.1030008@wwwdotorg.org>
Date: Tue, 05 Jun 2012 10:14:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: khali@linux-fr.org, w.sang@pengutronix.de, ben-linux@fluff.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/4] i2c: tegra: Bug fixes, cleanups and M_NOSTART support
References: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1338901800-23968-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 07:09 AM, Laxman Dewangan wrote:
> This patch series having the:
> - Handling of late register write due to Tegra PPSB design.
> - support for I2C_M_NOSTART
> - Use devm_* for all allocation.

The series,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Note that patch 4 touches context adjacent to Prashant's "i2c: tegra:
Add clk_prepare/clk_unprepare" patch, which I hope to take through the
Tegra tree since it's a requirement for the Tegra common clock
conversion. I don't think this will cause any significant conflict, but
perhaps it's worth resolving it explicitly.

Wolfram, perhaps we should put these 4 patches and Prashan'ts into their
own topic branch so that you can merge it into the I2C tree, and I can
merge it into the Tegra tree too? Or, I can take everything through
Tegra if you want, and ack it.

Laxman, do you expect any more I2C-related changes this kernel cycle?
