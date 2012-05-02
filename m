Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2EBNdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:33:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49679 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2EBNdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:33:24 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Date: Wed, 2 May 2012 13:32:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>, h@pengutronix.de,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
References: <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org> <20120501181922.GD4089@opensource.wolfsonmicro.com> <20120502015650.GE17311@gmail.com>
In-Reply-To: <20120502015650.GE17311@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205021332.44699.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:zb6UXa3kLAbNZIi08hL7x+7pkgGSw3RFg7Cv6+IbEix
 JV2W05hIMK3h83cN6v9851ot0w3FNC62pRap6xbASoSN7QqS9s
 SAbXq77MTXASN4pMK0In7BIWVA1wLgCsKZE4PGkq5yKG1u+ycq
 5wwSZ5ArDusj1cOuu4gOz3rR6Gkw5mSOEz/+iyVxay9av/shnO
 43fKn+IwzUsIbpytarwBzixahFWEIHAMyISu2oQIgDt6cDxhem
 NJt+P3y3CGOu6O1LFiqmfOjF2rPWT9dV31iF920zkfdBEF1yI1
 XkpliliKUJ+W2+LdH3aHpWevu7i8lfuHnyE8OGI3h5NEenGEl7
 4xQ1u8MkilVcZyPtmsQDrfl5WrxeqiKufHSXBDG1k
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2012, Mike Turquette wrote:
> I was happy to push my changes to Linus directly (as discussed in
> previous mails) but I'm starting to think that maybe having Arnd absorb
> the clk-next branch as part of arm-soc would be the fastest way to
> assist platforms that are porting over.
> 
> Do the platform folks agree?  Is this suggestion sane?

I guess that makes sense while there are still nontrivial
interdependencies between work going the clk-next branch and into
arm-soc.

	Arnd
