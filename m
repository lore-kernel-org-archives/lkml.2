Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1LLJK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:10:59 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56878 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1LLJKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:10:55 -0500
Message-ID: <20197.50444.333155.552035@ipc1.ka-ro>
Date: Mon, 12 Dec 2011 10:10:36 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, alsa-devel@alsa-project.org,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: mxs: add .owner to struct
 snd_soc_card
In-Reply-To: <20111211025358.GB2800@opensource.wolfsonmicro.com>
References: <cover.1323436034.git.LW@KARO-electronics.de>
	<555be1750dd09586d5eede6457f72310890274b0.1323436034.git.LW@KARO-electronics.de>
	<20111209141203.GH3327@pengutronix.de>
	<20194.7382.414612.182139@ipc1.ka-ro>
	<20111211025358.GB2800@opensource.wolfsonmicro.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mark Brown writes:
> On Fri, Dec 09, 2011 at 03:36:06PM +0100, Lothar Waßmann wrote:
> > Wolfram Sang writes:
> 
> > > I can't find any other instance setting owner in snd_soc_card?
> 
> > Then that other uses are most probably faulty too.
> 
> This needs to be fixed up generally, not just for a specific driver.
>
There are 84 drivers affected by this. I did not check though whether
all of them are compilable as module.
I could provide a patch for all of these, but I can at most do a
compile testing for some of them.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
