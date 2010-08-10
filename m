Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab0HJRTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 13:19:00 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:65459 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0HJRSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 13:18:55 -0400
Subject: Re: [PATCH] regulator: tps6586x - add regulator_unregister() in
 tps6586x_regulator_remove()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <20100810150052.GK6416@rakim.wolfsonmicro.main>
References: <1281340686.20518.4.camel@mola>
	 <20100810150052.GK6416@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 18:18:40 +0100
Message-ID: <1281460720.3059.153.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 16:00 +0100, Mark Brown wrote:
> On Mon, Aug 09, 2010 at 03:58:06PM +0800, Axel Lin wrote:
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

