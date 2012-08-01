Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2HAT6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:58:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32933 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460Ab2HAT6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:58:47 -0400
Date: Wed, 1 Aug 2012 20:58:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: s2mps11: Fix ramp_delay settings for
 s2mps11_buck_ops
Message-ID: <20120801195845.GH4483@opensource.wolfsonmicro.com>
References: <1342507641.18110.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342507641.18110.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 02:47:21PM +0800, Axel Lin wrote:
> The ramp_delay settings were missing while converting to
> regulator_set_voltage_time_sel(). Fix it.

Applied, thanks.
