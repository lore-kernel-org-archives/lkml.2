Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab2HAUBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:01:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32972 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab2HAUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:01:10 -0400
Date: Wed, 1 Aug 2012 21:01:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp8788-buck: Remove
 lp8788_set_default_dvs_ctrl_mode function
Message-ID: <20120801200108.GM4483@opensource.wolfsonmicro.com>
References: <1342794140.3401.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342794140.3401.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 10:22:20PM +0800, Axel Lin wrote:
> We already know the mask in lp8788_init_dvs() function, and we can update
> the corresponding bit for default_dvs_mode in lp8788_init_dvs() function.
> This function looks not necessary to me.

Applied, thanks.
