Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab2CJSdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:33:01 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56482 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751547Ab2CJSc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:32:59 -0500
Message-ID: <1331404377.14442.19.camel@joe2Laptop>
Subject: Re: [PATCH] drivers/ata/pata_mpc52xx.c: add missing kfree
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>, Anatolij Gustschin <agust@denx.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Jeff Garzik <jgarzik@pobox.com>,
        kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Date: Sat, 10 Mar 2012 10:32:57 -0800
In-Reply-To: <20120310181315.GA4139@pengutronix.de>
References: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
	 <20120310181315.GA4139@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-10 at 19:13 +0100, Wolfram Sang wrote:
> On Sat, Mar 10, 2012 at 06:56:39PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > There is no need to call the devm cleanup functions on failure of a probe
> > or remove function.
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> the maintainer for MPC5xxx is Anatolij

Anatolij is not listed as a maintainer for this file
nor has he ever written or signed a patch for it.

It'd be possible to add patterns to MAINTAINERS
if Anatolij really wants to see changes to drivers.

Something like:

LINUX FOR POWERPC EMBEDDED MPC5XXX
M:	Anatolij Gustschin <agust@denx.de>
L:	linuxppc-dev@lists.ozlabs.org
T:	git git://git.denx.de/linux-2.6-agust.git
S:	Maintained
F:	arch/powerpc/platforms/512x/
F:	arch/powerpc/platforms/52xx/
F:	*/*/*mpc5[\dx][\dx][\dx]*
F:	*/*/*/*mpc5[\dx][\dx][\dx]*
F:	*/*/*/*/*mpc5[\dx][\dx][\dx]*


