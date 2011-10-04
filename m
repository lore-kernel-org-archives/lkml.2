Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab1JDUkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:40:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63932 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933628Ab1JDUkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:40:32 -0400
Date: Tue, 4 Oct 2011 14:35:20 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Stijn Devriendt <highguy@gmail.com>
Subject: Re: [PATCH] drivers: create a pin control subsystem v8
Message-ID: <20111004203520.GK2870@ponder.secretlab.ca>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
 <20110930020754.GK12606@ponder.secretlab.ca>
 <CACRpkdYyyqB6=5M8reqgwpMxXJz5ttXWyOav6K58dQ0CrxwCNA@mail.gmail.com>
 <CACxGe6v19pZ0i-+ksYZbG2ZvGT30UkXEHTzpZMBTB4RNUV5bnA@mail.gmail.com>
 <CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKnu2MpQ8Wvd4TF8Ge=o8ACyEoaEY8TcvOSdT1w6zfYiSKFUiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 12:39:21PM +0200, Linus Walleij wrote:
> 2011/9/30 Grant Likely <grant.likely@secretlab.ca>:
> 
> > I'm not convinced that the sysfs approach is
> > actually the right interface here (I'm certainly not a fan of the gpio
> > sysfs i/f), and I'd rather not be putting in unneeded stuff until the
> > userspace i/f is hammered out.
> 
> Actually, thinking about it I cannot see what would be wrong
> with /dev/gpio0 & friends in the first place.
> 
> Using sysfs as swiss army knife for custom I/O does not
> seem like it would be long-term viable so thanks for this
> observation, and I think we need /dev/gpio* put on some
> mental roadmap somewhere.

Agreed.  I don't want to be in the situation we are now with GPIO,
where every time I look at the sysfs interface I shudder.

g.

