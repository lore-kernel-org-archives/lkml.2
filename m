Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1GVKsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:48:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50543 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1GVKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:47:44 -0400
Subject: Re: [PATCH v2] regulator: tps65910: Add missing breaks in
 switch/case
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>
In-Reply-To: <20110710110943.GA24191@opensource.wolfsonmicro.com>
References: <1310294482.4877.3.camel@phoenix>
	 <20110710110943.GA24191@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 11:47:38 +0100
Message-ID: <1311331658.3312.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-10 at 20:09 +0900, Mark Brown wrote:
> On Sun, Jul 10, 2011 at 06:41:22PM +0800, Axel Lin wrote:
> > Also add a default case in tps65910_list_voltage_dcdc to silence
> > 'volt' may be used uninitialized in this function warning.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> though for the default case I'd suggest also adding a BUG() as if that
> happens either the driver is confused or the core is making up
> regulators for us.
> --

Applied.

Thanks

Liam

