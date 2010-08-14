Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720Ab0HNLQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 07:16:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46619 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934694Ab0HNLQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 07:16:03 -0400
Subject: Re: [patch] regulator/ab8500: move dereference below the check for
 NULL
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dan Carpenter <error27@gmail.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <64F33A1C-EB54-4DFF-85C7-6796CFF475BA@opensource.wolfsonmicro.com>
References: <20100814090316.GX645@bicker>
	 (sfid-20100814_100351_685395_0B6B8F07)  <64F33A1C-EB54-4DFF-85C7-6796CFF475BA@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Aug 2010 12:15:57 +0100
Message-ID: <1281784557.3394.150.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-14 at 10:36 +0100, Mark Brown wrote:
> On 14 Aug 2010, at 10:03, Dan Carpenter wrote:
> 
> > I moved the dereference of "ab8500" below the check for NULL.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

