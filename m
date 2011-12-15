Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab1LOSQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:16:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1LOSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:16:53 -0500
Date: Thu, 15 Dec 2011 10:16:46 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Gary King <gking@nvidia.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v7 00/14] Add support for tegra30 and cardhu
Message-ID: <20111215181646.GA10631@quad.lixom.net>
References: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 05:03:12PM +0200, Peter De Schrijver wrote:
> This patchset adds support for the tegra30 SoC and the cardhu development
> board.
> 
> Patchset is on top of linux-next and
> http://www.spinics.net/lists/linux-tegra/msg03016.html.
> 
> Most important changes in v7:
> 
> * split board-dt.c in board-dt-tegra20.c and board-dt-tegra30.c
> * split early init preparation into several patches
> * remove tegra_sdmmc_tap_delay. Drivers should use tegra2_sdmmc_tap_delay as
>   from tegra30 onwards this feature will no longer handled by the clock code
>   as it's implemented in the SDMMC block now.
> * remove CONFIG_CARDHU and the corresponding Kconfig entry

Thanks, this is looking pretty good by now, and remaining rough edges
(if any), can be fixed up over time as well.

I'm ok with it going in but lets have it sit for another day or two until
Stephen is back and has a chance to look it through as well. Colin had
some questions that I want to make sure he's happy with the answers to
as well.


-Olof

