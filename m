Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0HXOBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:01:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44486 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab0HXOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:01:30 -0400
Subject: Re: [PATCH] regulator: max8998 - set max8998->num_regulators
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20100823100128.GE6061@rakim.wolfsonmicro.main>
References: <1282462009.2989.2.camel@phoenix>
	 <20100823100128.GE6061@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 15:01:24 +0100
Message-ID: <1282658484.3053.61.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 11:01 +0100, Mark Brown wrote:
> On Sun, Aug 22, 2010 at 03:26:49PM +0800, Axel Lin wrote:
> > Set max8998->num_regulators = pdata->num_regulators,
> > otherwise it's default value is 0.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

