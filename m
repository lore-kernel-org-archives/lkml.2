Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0JMUGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:06:25 -0400
Received: from mail.perches.com ([173.55.12.10]:2905 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab0JMUGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:06:24 -0400
Subject: Re: [RFC PATCH] sound/soc/codecs/wm8962.c: Use register index,
 save 100kb text
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
In-Reply-To: <20101013194017.GB17574@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
	 <1286934472.1117.129.camel@Joe-Laptop>
	 <20101013082414.GD6424@rakim.wolfsonmicro.main>
	 <1286971846.1117.191.camel@Joe-Laptop>
	 <20101013123301.GL6424@rakim.wolfsonmicro.main>
	 <1286974549.1117.254.camel@Joe-Laptop>
	 <20101013151117.GM6424@rakim.wolfsonmicro.main>
	 <1286983667.1117.347.camel@Joe-Laptop>
	 <20101013152916.GA20270@rakim.wolfsonmicro.main>
	 <1286997031.1117.405.camel@Joe-Laptop>
	 <20101013194017.GB17574@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 13:06:22 -0700
Message-ID: <1287000382.1117.416.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 20:40 +0100, Mark Brown wrote:
> The size impact of doing something
> simple is a bit annoying but not usually a pressing issue on devices
> that would want a CODEC with a noticably large register map.

I think wasting 100+ KB is excessive if I
were designing some cheap mp3 player.

Up to you how/when it should be resolved/fixed,
but I think it should be.

