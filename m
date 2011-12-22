Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1LVRni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:43:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39390 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab1LVRnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:43:35 -0500
Date: Thu, 22 Dec 2011 17:43:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111222174327.GE29622@opensource.wolfsonmicro.com>
References: <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
 <4EDFAA0A.7040607@solonet.org.ua>
 <20111207160002.8b52df42.akpm@linux-foundation.org>
 <20111208011904.GD5748@opensource.wolfsonmicro.com>
 <2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
 <20111214113714.GJ3072@opensource.wolfsonmicro.com>
 <20111214140155.GB3999@bnru02.bnr.st.com>
 <CACRpkdaE16-bbvsfzAK2DAmZRqswPvubzt_5ScLpQhDvcDc3uw@mail.gmail.com>
 <20111215071113.GD24248@opensource.wolfsonmicro.com>
 <20111216051031.GA13690@bnru05.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216051031.GA13690@bnru05.bnr.st.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 10:40:31AM +0530, Shreshtha Kumar SAHU wrote:

> Please provide feedback on this, if it fulfills the requirement.

That seems reasonable to me, my only concern was that we had this extra
knob for essentially the same thing so so long as it all comes down to
one brightness control that's addressed.
