Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0G0Kfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:35:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58096 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0G0Kfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:35:30 -0400
Subject: Re: [PATCH resend] ab3100: fix off-by-one value range checking for
  voltage selector
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
In-Reply-To: <AANLkTimbM5=bEhtQrWj1H1nX3gqkdZskGz5KvA6WL3=v@mail.gmail.com>
References: <1280129654.26844.3.camel@mola>
	 <AANLkTimbM5=bEhtQrWj1H1nX3gqkdZskGz5KvA6WL3=v@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 11:35:20 +0100
Message-ID: <1280226920.3085.22.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-26 at 11:02 +0200, Linus Walleij wrote:
> 2010/7/26 Axel Lin <axel.lin@gmail.com>:
> 
> > We use voltage selector as an array index for typ_voltages.
> > Thus the valid range for voltage selector should be 0..voltages_len-1.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

