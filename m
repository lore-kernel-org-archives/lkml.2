Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1JYIXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:23:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41566 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1JYIXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:23:43 -0400
Date: Tue, 25 Oct 2011 09:23:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stijn Devriendt <highguy@gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
Message-ID: <20111025082334.GA21616@sirena.org.uk>
References: <CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
 <CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
 <20111004203520.GK2870@ponder.secretlab.ca>
 <CAMjpGUe9abPsdWbum2MRzOV2b5_2FDqXZC-K0KThRA6MNTr4FA@mail.gmail.com>
 <CACRpkdatiBathcoo2VjKs9jHJiKC5trDCJ0bePX1q6KbrYRN-g@mail.gmail.com>
 <20111024073604.GA8708@ponder.secretlab.ca>
 <CACRpkdZ6DCeELLhiXF=oOMKB-DxeMuvbd_c6n4H1UDMhpHKZbA@mail.gmail.com>
 <20111024110518.GG8708@ponder.secretlab.ca>
 <20111025080532.GI4429@atomide.com>
 <20111025081719.GA4605@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025081719.GA4605@ponder.secretlab.ca>
X-Cookie: For off-road use only.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 10:17:19AM +0200, Grant Likely wrote:

> I've got no issue with a debugfs interface, although it would probably
> a good idea to put a big scary warning into klog when userspace starts
> manipulating pinctrl setting.  Maybe should taint the kernel too.

Yes, we really should taint the kernel for any non-mediated interface -
never mind instability this stuff can cause physical damage if you get
it wrong.
