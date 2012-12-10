Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab2LJDXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 22:23:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32909 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab2LJDXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 22:23:09 -0500
Date: Mon, 10 Dec 2012 12:23:04 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp872x: Kill _rdev_to_offset() function
Message-ID: <20121210032302.GE10927@opensource.wolfsonmicro.com>
References: <1354931808.6623.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354931808.6623.0.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 09:56:48AM +0800, Axel Lin wrote:
> There is only one user calling _rdev_to_offset() function.
> Remove _rdev_to_offset() makes the code simpler.

Applied, thanks.

Milo, you should probably add a MAINTAINERS entry for this one too.
