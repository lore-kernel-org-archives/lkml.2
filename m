Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2ASDwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 22:52:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55118 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab2ASDws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 22:52:48 -0500
Date: Wed, 18 Jan 2012 19:52:52 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm/tegra: add support for tegra30 interrupts
Message-ID: <20120119035252.GB7145@quad.lixom.net>
References: <1325770305-21637-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325770305-21637-1-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:31:45PM +0200, Peter De Schrijver wrote:
> Tegra30 has 1 extra legacy interrupt controller. Use the GIC ITLinesNumber
> field to determine how many interrupt controllers we have and initialize
> appropriately. Also make room for the extra tegra30 interrupts by moving
> the GPIO IRQ base. This shouldn't affect existing code as it determines the
> correct IRQ number for GPIOs using TEGRA_GPIO_TO_IRQ().
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Colin Cross <ccross@android.com>

Thanks, applied.


-Olof
