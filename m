Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2GaOQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:16:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53451 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108Ab2GaOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:15:57 -0400
Date: Tue, 31 Jul 2012 15:15:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: I2C dummy, regmap, irq domain issue
Message-ID: <20120731141555.GT4468@opensource.wolfsonmicro.com>
References: <5017E789.4010701@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5017E789.4010701@slimlogic.co.uk>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:11:21PM +0100, Graeme Gregory wrote:

> -        d->domain = irq_domain_add_legacy(map->dev->of_node,
> +        d->domain = irq_domain_add_legacy(dev->of_node,

Oh, ick.  If we're going to have to do this sort of stuff we should just
pass the of_node in and have done with it.
