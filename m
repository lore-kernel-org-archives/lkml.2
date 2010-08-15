Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0HOPmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:42:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37805 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757759Ab0HOPms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:42:48 -0400
Date: Sun, 15 Aug 2010 14:47:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: tps6507x - remove incorrect comments
Message-ID: <20100815134741.GC26969@opensource.wolfsonmicro.com>
References: <1281796333.3780.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281796333.3780.4.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 10:32:13PM +0800, Axel Lin wrote:
> This driver is a platform driver, not a i2c driver.
> Thus remove incorrect tps6507x_remove comments.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
