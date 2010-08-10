Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab0HJRSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 13:18:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43483 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0HJRSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 13:18:33 -0400
Subject: Re: [PATCH RESEND] regulator: tps6507x - add missing
 platform_set_drvdata in tps6507x_pmic_probe
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>
In-Reply-To: <20100810144608.GI6416@rakim.wolfsonmicro.main>
References: <1281340283.20518.1.camel@mola>
	 <20100810144608.GI6416@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 18:18:27 +0100
Message-ID: <1281460707.3059.152.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 15:46 +0100, Mark Brown wrote:
> On Mon, Aug 09, 2010 at 03:51:23PM +0800, Axel Lin wrote:
> > We should call platform_set_drvdata() before calling platform_get_drvdata().
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> --

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

