Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2HAT5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:57:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32917 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172Ab2HAT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:57:24 -0400
Date: Wed, 1 Aug 2012 20:57:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] regulator: twl: Fix checking voltage range in
 twl6030smps_set_voltage()
Message-ID: <20120801195721.GG4483@opensource.wolfsonmicro.com>
References: <1342244233.4207.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342244233.4207.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 01:37:13PM +0800, Axel Lin wrote:
> The voltage selection logic is supposed to find the samllest voltage falls
> within specified range. When using equation to calculate vsel, we need to
> ensure the requested min_uV meet the range of using the equation.
> Otherwise we may select a voltage that is out of specified range.

Applied both, thanks.
