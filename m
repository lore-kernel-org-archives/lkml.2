Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1JUPYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 11:24:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57226 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab1JUPYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 11:24:36 -0400
Date: Fri, 21 Oct 2011 16:24:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
Message-ID: <20111021152434.GG4080@opensource.wolfsonmicro.com>
References: <CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
 <CACRpkdYCgY9w8UgMKLgxSsu=Veo01-YSKBWndqU_uCTE-GjZuQ@mail.gmail.com>
 <20111020141827.GB6100@sirena.org.uk>
 <CACRpkdaaUmze+W1n4NkApTX0Se1VJAmD+AJSm36QbsKVDzdnRA@mail.gmail.com>
 <20111020154244.GA26083@opensource.wolfsonmicro.com>
 <CACRpkdbJbUefH+Q0GMp+_4FhV5RqQ+KHrGnJLR6jZSNR16NbSw@mail.gmail.com>
 <20111021123041.GE4080@opensource.wolfsonmicro.com>
 <CACRpkdaZQ12W2M9m=vvQ=w6vRppgsZdphm4ftmx6uFAX2HDkog@mail.gmail.com>
 <20111021125544.GF4080@opensource.wolfsonmicro.com>
 <CACRpkdbQYcMaK50EJ6n0UXGFfWWw_9YD_abTNDmqBxWxycC6NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbQYcMaK50EJ6n0UXGFfWWw_9YD_abTNDmqBxWxycC6NQ@mail.gmail.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:57:19PM +0200, Linus Walleij wrote:
> On Fri, Oct 21, 2011 at 2:55 PM, Mark Brown

> > No, like I keep saying it's nothing to do with enabling or disabling
> > power.  It's about selecting between multiple reference domains.  For
> > example, choosing between the DBVDD1 and DBVDD2 domains.

> OK I think I get it now.

> So PIN_CONFIG_POWER_SOURCE and then the argument to
> that is definately custom...

I'd probably go with _DOMAIN rather than _SOURCE but yes.
