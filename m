Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0IALyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:54:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33992 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab0IALyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:54:12 -0400
Subject: Re: [PATCH] regulator: ad5398 - fix a memory leak
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Sonic Zhang <sonic.zhang@analog.com>
In-Reply-To: <20100901091544.GB17032@opensource.wolfsonmicro.com>
References: <1283308158.23075.1.camel@mola>
	 <20100901091544.GB17032@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 12:54:08 +0100
Message-ID: <1283342048.3081.148.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 10:15 +0100, Mark Brown wrote:
> On Wed, Sep 01, 2010 at 10:29:18AM +0800, Axel Lin wrote:
> > In current implementation, the address return from regulator_register()
> > is different from the address for regulator_unregister().
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

