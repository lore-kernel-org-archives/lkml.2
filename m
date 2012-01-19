Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2ASMX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:23:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7906 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2ASMXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:23:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Jan 2012 04:23:24 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 19 Jan 2012 17:53:20 +0530
Subject: RE: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for
 rails.
Thread-Topic: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for
 rails.
Thread-Index: AczWmchR1P5USUtyRLe+18DFiPkNmwACt+pg
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DC3DCC2EC@BGMAIL01.nvidia.com>
References: <1326899836-14470-1-git-send-email-ldewangan@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAE10@HQMAIL01.nvidia.com>
 <20120118175613.GT8732@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DC3DCC1C3@BGMAIL01.nvidia.com>
 <20120119104029.GA3178@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DC3DCC2B6@BGMAIL01.nvidia.com>
 <20120119110154.GD3178@opensource.wolfsonmicro.com>
In-Reply-To: <20120119110154.GD3178@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 January 2012 04:31 PM, Mark Brown wrote:

> > The table_len is already used in some of entry i.e. for tps65910. I filled
> > entry for another device tps65911. So I would like to go for separate patch
> > for renaming the variables "table" to "voltage_table" and "table_len" to
> > "n_voltages".
> > Please let me know your opinion.
> 
> That's fine.  If in doubt and it doesn't introduce build breakage
> splitting up into more patches is rarely a problem.


Ok, So to avoid the mess-ups, I will fetch the code from your tree 
http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=shortlog;h=refs/heads/for-next-next
once you apply this change and then push the variable name change in new patch.

Laxman
