Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1DRWQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:16:21 -0400
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:27166
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585Ab1DRWQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:16:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAEa3rE3LrQ63/2dsb2JhbAAMrxq9WoVxBJIQ
X-IronPort-AV: E=Sophos;i="4.64,235,1301846400"; 
   d="scan'208";a="262689968"
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <20110418115903.GB9462@sirena.org.uk>
Date: Tue, 19 Apr 2011 08:16:12 +1000
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <34EB51B7-AF3B-4DCE-A402-953B2DBC0474@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com> <20110418091902.13345132@lxorguk.ukuu.org.uk> <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com> <20110418115903.GB9462@sirena.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18/04/2011, at 9:59 PM, Mark Brown wrote:

> On Mon, Apr 18, 2011 at 06:50:12PM +1000, Ben Nizette wrote:
> 
> Please fix your MUA to word wrap within paragraphs; I've reflowed your
> text for legibility.

Sorry, I apologised in advance in my first email, I've made the mistake
of travelling without a sane MUA :)

> 
>> Still my question stands, where is the driver ever better placed to
>> make these calls than the board code?
> 
> Even if it ends up being the board code using these APIs it seems
> sensible to have a standard API that GPIO drivers can use to expose the
> functionality.  This will help with getting control into code Linux owns
> (since people don't have to implement custom APIs) and will mean we can
> do things like add control of this for device tree based boards.

Oh I'm all for platform-specific libraries abstracting this away from the
board code if that helps, that's certainly the way that, eg, AVR32 does it.
It just doesn't make sense to me to bounce from the board code in to
'generic' gpio code then back to platform-specific implementations when
you could cut out the middle man.

	--Ben.
