Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0KKMJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:09:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54810 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab0KKMJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:09:14 -0500
Subject: Re: linux-next: build failure after merge of the voltage tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101111114644.GC6052@rakim.wolfsonmicro.main>
References: <20101111113638.eb3101d0.sfr@canb.auug.org.au>
	 <20101111114644.GC6052@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 12:09:10 +0000
Message-ID: <1289477350.3273.10.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 11:46 +0000, Mark Brown wrote:
> On Thu, Nov 11, 2010 at 11:36:38AM +1100, Stephen Rothwell wrote:
> 
> > After merging the voltage tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> 
> Oh, a platform where pcap can actually be built!  That's useful, thanks.
> 
> > drivers/regulator/pcap-regulator.c:155: error: expected declaration specifiers or '...' before 'unsiged'
> > drivers/regulator/pcap-regulator.c: In function 'pcap_regulator_set_voltage':
> > drivers/regulator/pcap-regulator.c:175: error: 'selector' undeclared (first use in this function)
> > drivers/regulator/pcap-regulator.c: At top level:
> > drivers/regulator/pcap-regulator.c:251: warning: initialization from incompatible pointer type
> 
> > Caused by commit d2f03ebfe8c63d1e3e1ab2352dd32d161546003e ("regulator:
> > Report actual configured voltage to set_voltage()").  Please always build
> > changed files ...
> 
> With a lot of the embedded drivers that can be difficult - often there
> are dependencies on APIs that are only available on a small set of
> platforms (which may not even be documented).  For example, with PCAP
> the core driver uses irq_to_gpio() which is not implemented on any of
> the platforms I commonly build for.
> --

Fix now applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

