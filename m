Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0HWKCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:02:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34738 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752141Ab0HWKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:02:51 -0400
Date: Mon, 23 Aug 2010 11:02:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask
 parameter for tps6586x_set_bits()
Message-ID: <20100823100248.GG6061@rakim.wolfsonmicro.main>
References: <1282487895.23014.19.camel@phoenix>
 <1282488162.23014.24.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282488162.23014.24.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 10:42:42PM +0800, Axel Lin wrote:
> The third parameter of tps6586x_set_bits() is the bit_mask,
> thus we should use (1 << ri->go_bit) instead of ri->go_bit.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but I'd be much happier if someone who actually has the hardware could
verify that this is OK.
