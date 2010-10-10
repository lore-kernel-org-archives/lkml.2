Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0JJKOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:14:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51023 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab0JJKOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:14:38 -0400
Subject: Re: [PATCH] regulator: Add option for machine drivers to enable
 the dummy regulator
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Walleij <linus.ml.walleij@gmail.com>
In-Reply-To: <1286331512-4608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1286331512-4608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 11:14:31 +0100
Message-ID: <1286705671.3429.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 19:18 -0700, Mark Brown wrote:
> Allow machine drivers to explicitly enable the use of the dummy regulator,
> enabling simpler support for systems with only a few specific supplies
> visible to software.
> 
> It is strongly recommended that this is not used on systems with
> substantial software control over their PMICs, for maximum functionality
> constrints should be as fully specified as possible.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

