Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab1LOHLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:11:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53377 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab1LOHLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:11:19 -0500
Date: Thu, 15 Dec 2011 15:11:14 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111215071113.GD24248@opensource.wolfsonmicro.com>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
 <4EDAA785.40503@solonet.org.ua>
 <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
 <4EDFAA0A.7040607@solonet.org.ua>
 <20111207160002.8b52df42.akpm@linux-foundation.org>
 <20111208011904.GD5748@opensource.wolfsonmicro.com>
 <2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
 <20111214113714.GJ3072@opensource.wolfsonmicro.com>
 <20111214140155.GB3999@bnru02.bnr.st.com>
 <CACRpkdaE16-bbvsfzAK2DAmZRqswPvubzt_5ScLpQhDvcDc3uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaE16-bbvsfzAK2DAmZRqswPvubzt_5ScLpQhDvcDc3uw@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 07:34:50PM +0100, Linus Walleij wrote:

> The problem is I think this table is dependent on the LED fitted
> and needs to be supplied as platform data from the board,
> which knows which LED is on that board.

To a good approximation the restriction from the LED comes from the
maximum current it can sustain so it's usually a fairly simple input.
