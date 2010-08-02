Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0HBKJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:09:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40910 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0HBKJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:09:33 -0400
Subject: Re: [PATCH] regulator: tps6586x: fix millivolt return values and
 SM2 table
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org,
        Gary King <gking@nvidia.com>
In-Reply-To: <20100730202017.GA29726@opensource.wolfsonmicro.com>
References: <1280519938-3089-1-git-send-email-mike@compulab.co.il>
	 <20100730202017.GA29726@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 11:09:29 +0100
Message-ID: <1280743769.3095.34.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 13:20 -0700, Mark Brown wrote:
> On Fri, Jul 30, 2010 at 10:58:58PM +0300, Mike Rapoport wrote:
> > From: Gary King <gking@nvidia.com>
> > 
> > Hi Liam,
> > Below are bugfixes for the tps6586x spotted by Gary King.
> > Please add this patch to your regulator tree.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> --

Applied.

Thanks.

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

