Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab1GRJom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:44:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52857 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755182Ab1GRJol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:44:41 -0400
Date: Mon, 18 Jul 2011 18:44:37 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps65912: Remove unused define of
 TPS65912_MAX_REG_ID
Message-ID: <20110718094436.GB423@opensource.wolfsonmicro.com>
References: <1310958137.23337.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310958137.23337.1.camel@phoenix>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:02:17AM +0800, Axel Lin wrote:
> Currently we define TPS65912_MAX_REG_ID as TPS65912_REG_LDO_10,
> but TPS65912_REG_LDO_10 is not defined at all.
> ( It looks like a typo of TPS65912_REG_LDO10 )
> Currently, TPS65912_MAX_REG_ID is not used in this driver,
> it is safe to just remove it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
