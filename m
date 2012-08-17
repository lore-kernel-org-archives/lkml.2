Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2HQSlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:41:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52396 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab2HQSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:41:31 -0400
Message-ID: <502E9051.4090507@wwwdotorg.org>
Date: Fri, 17 Aug 2012 12:41:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: dynamically control fast clk
References: <1345189711-24104-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1345189711-24104-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 01:48 AM, Laxman Dewangan wrote:
> Tegra I2C driver enables the fast clock during initialization
> and does not disable till driver removed.
> Enable this clock before transfer and disable after transfer done.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> This patch is on top of the clock chnages which is in Tegra sub system and
> based on 
>  i2c: tegra: I2_M_NOSTART functionality not supported in Tegra20
> So recommend to go on tegra sub-system.

What exactly is this patch based on? I checked out Tegra's
for-3.7/drivers-i2c, cherry-picked the M_NOSTART patch you mentioned,
and attempted to apply this patch. It doesn't apply. Same if I don't
cherry-pick the M_NOSTART patch, and same for next-20120816 with/without
the M_NOSTART patch.
