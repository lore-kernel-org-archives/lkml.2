Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab0JJKOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:14:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49646 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab0JJKOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:14:51 -0400
Subject: Re: [PATCH v2] regulator: avoid deadlock when disabling regulator
 with supply
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jeffrey Carlyle <jeff.carlyle@motorola.com>,
        Lun Chang <L.chang@motorola.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20101008211042.GC6098@opensource.wolfsonmicro.com>
References: <20101008185739.GA6098@opensource.wolfsonmicro.com>
	 <1286567360-11337-1-git-send-email-jeff.carlyle@motorola.com>
	 <20101008211042.GC6098@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 11:14:47 +0100
Message-ID: <1286705687.3429.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 14:10 -0700, Mark Brown wrote:
> On Fri, Oct 08, 2010 at 02:49:19PM -0500, Jeffrey Carlyle wrote:
> > I have a regulator A that sets regulator B as its supply. When I call
> > set_supply to add B as the supply for A, regulator A gets added to the
> > supply_list for regulator B.
> > 
> > When I call regulator_disable(A), I end up with a call chain like this:
> 
> Looks good!
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

