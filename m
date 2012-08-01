Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2HAUAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:00:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32965 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756Ab2HAUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:00:44 -0400
Date: Wed, 1 Aug 2012 21:00:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp8788-ldo: Set n_voltages to 1 for fixed
 voltage
Message-ID: <20120801200042.GL4483@opensource.wolfsonmicro.com>
References: <1342787479.3531.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342787479.3531.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 08:31:19PM +0800, Axel Lin wrote:
> For fixed voltage, the n_voltages should be 1 rather than 0.

Applied, thanks.
