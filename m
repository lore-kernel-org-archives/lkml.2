Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2ASLB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:01:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49283 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab2ASLB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:01:57 -0500
Date: Thu, 19 Jan 2012 11:01:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for
 rails.
Message-ID: <20120119110154.GD3178@opensource.wolfsonmicro.com>
References: <1326899836-14470-1-git-send-email-ldewangan@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAE10@HQMAIL01.nvidia.com>
 <20120118175613.GT8732@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DC3DCC1C3@BGMAIL01.nvidia.com>
 <20120119104029.GA3178@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DC3DCC2B6@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DC3DCC2B6@BGMAIL01.nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 04:25:17PM +0530, Laxman Dewangan wrote:
> On Thursday 19 January 2012 04:10 PM, Mark Brown wrote:

> The table_len is already used in some of entry i.e. for tps65910. I filled
> entry for another device tps65911. So I would like to go for separate patch
> for renaming the variables "table" to "voltage_table" and "table_len" to
> "n_voltages".
> Please let me know your opinion.

That's fine.  If in doubt and it doesn't introduce build breakage
splitting up into more patches is rarely a problem.
