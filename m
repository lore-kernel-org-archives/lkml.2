Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0FOKqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:46:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51806 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab0FOKqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:46:38 -0400
Subject: Re: [PATCH] regulator: make sure the regulator is available prior
 to the consumers.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       sonic zhang <sonic.adi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
In-Reply-To: <20100610114907.GC17945@opensource.wolfsonmicro.com>
References: <1276160027.18479.1.camel@eight.analog.com>
	 <20100610114907.GC17945@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 11:46:33 +0100
Message-ID: <1276598793.3003.34.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 12:49 +0100, Mark Brown wrote:
> On Thu, Jun 10, 2010 at 04:53:47PM +0800, sonic zhang wrote:
> > >From 5a71b38961b0889a239842defd733774ed3d9cdf Mon Sep 17 00:00:00 2001
> > From: Sonic Zhang <sonic.zhang@analog.com>
> > Date: Thu, 10 Jun 2010 16:50:20 +0800
> > Subject: [PATCH] regulator: make sure the regulator is available prior to the consumers.
> > 
> > Some systems are likely to want this to be subsys_initcall() to
> > make sure the regulator is available prior to the consumers.
> > 
> > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

