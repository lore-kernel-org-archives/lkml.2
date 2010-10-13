Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0JMP3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:29:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38212 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752146Ab0JMP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:29:19 -0400
Date: Wed, 13 Oct 2010 16:29:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] sound/soc: rename vol to volatile_register as
 appropriate
Message-ID: <20101013152916.GA20270@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
 <1286934472.1117.129.camel@Joe-Laptop>
 <20101013082414.GD6424@rakim.wolfsonmicro.main>
 <1286971846.1117.191.camel@Joe-Laptop>
 <20101013123301.GL6424@rakim.wolfsonmicro.main>
 <1286974549.1117.254.camel@Joe-Laptop>
 <20101013151117.GM6424@rakim.wolfsonmicro.main>
 <1286983667.1117.347.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286983667.1117.347.camel@Joe-Laptop>
X-Cookie: Dealer prices may vary.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 08:27:47AM -0700, Joe Perches wrote:
> On Wed, 2010-10-13 at 16:11 +0100, Mark Brown wrote:

> > If you check the code again you will notice that these functons are all
> > used in ops structures which presents obvious issues when trying to
> > replace with open coded checks.
> > I hope their usefulness is clear given the above.

> There is some value in using consistent
> function styles for table driven and non-table
> driven instances.

I'm sorry, I don't understand what you are saying here.  What do you
believe to be inconsistent?
