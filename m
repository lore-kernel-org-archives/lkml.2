Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1HDIWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:22:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46880 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751874Ab1HDIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:22:39 -0400
Date: Thu, 4 Aug 2011 09:22:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: 88pm8607: Fix off-by-one value range
	checking in the case of no id is matched
Message-ID: <20110804082237.GA24602@opensource.wolfsonmicro.com>
References: <1312445891.5448.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312445891.5448.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 04:18:11PM +0800, Axel Lin wrote:
> In the case of no id is matched, the variable i is equal to
> ARRAY_SIZE(pm8607_regulator_info).
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> I think compare variable i with ARRAY_SIZE(pm8607_regulator_info) here is slightly
> better in readability than compare with PM8607_ID_RG_MAX.

It should be more robust I guess.
