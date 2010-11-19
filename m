Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0KSMPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:15:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49828 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0KSMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:15:35 -0500
Subject: Re: [PATCH] ASoC: Move kfree(twl4030) to twl4030_soc_remove()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Steve Sakoman <steve@sakoman.com>
In-Reply-To: <20101119112546.GI7233@rakim.wolfsonmicro.main>
References: <1290159068.10001.5.camel@mola>
	 <20101119112546.GI7233@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 12:15:31 +0000
Message-ID: <1290168931.3276.19.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 11:25 +0000, Mark Brown wrote:
> On Fri, Nov 19, 2010 at 05:31:08PM +0800, Axel Lin wrote:
> > As we allocate memory for twl4030 in twl4030_codec_probe(),
> > twl4030_codec_remove() is a better place to free the memory.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

