Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0HWKBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:01:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34731 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752141Ab0HWKBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:01:52 -0400
Date: Mon, 23 Aug 2010 11:01:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH 1/2] regulator: tps6586x-regulator - fix value range
 checking for val
Message-ID: <20100823100150.GF6061@rakim.wolfsonmicro.main>
References: <1282487895.23014.19.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282487895.23014.19.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 10:38:15PM +0800, Axel Lin wrote:
> val is used as array index of ri->voltages.
> Thus the valid value range should be 0 .. ri->desc.n_voltages - 1.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
