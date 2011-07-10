Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1GJLKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:10:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38489 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750817Ab1GJLKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:10:16 -0400
Date: Sun, 10 Jul 2011 20:09:50 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] regulator: tps65910: Add missing breaks in switch/case
Message-ID: <20110710110943.GA24191@opensource.wolfsonmicro.com>
References: <1310294482.4877.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310294482.4877.3.camel@phoenix>
X-Cookie: Never reveal your best argument.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 06:41:22PM +0800, Axel Lin wrote:
> Also add a default case in tps65910_list_voltage_dcdc to silence
> 'volt' may be used uninitialized in this function warning.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though for the default case I'd suggest also adding a BUG() as if that
happens either the driver is confused or the core is making up
regulators for us.
