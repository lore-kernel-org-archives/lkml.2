Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0KSLbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:31:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47540 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0KSLbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:31:34 -0500
Subject: Re: [PATCH] regulator: fix kernel-doc for
 set_consumer_device_supply
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20101119111859.GG7233@rakim.wolfsonmicro.main>
References: <20101118150226.d0614b85.randy.dunlap@oracle.com>
	 <20101119111859.GG7233@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 11:31:29 +0000
Message-ID: <1290166289.3276.17.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 11:18 +0000, Mark Brown wrote:
> On Thu, Nov 18, 2010 at 03:02:26PM -0800, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix kernel-doc warning for set_consumer_device_supply():
> > 
> > Warning(drivers/regulator/core.c:912): missing initial short description on line:
> >  * set_consumer_device_supply: Bind a regulator to a symbolic supply
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

