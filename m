Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161333Ab2GLQh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:37:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47167 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab2GLQhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:37:51 -0400
Date: Thu, 12 Jul 2012 17:37:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ
 mapping
Message-ID: <20120712163747.GB4488@sirena.org.uk>
References: <4FF6994B.9040801@linaro.org>
 <20120706173957.GA10202@core.coreip.homeip.net>
 <4FFB288D.4080606@linaro.org>
 <20120709201422.GA12242@core.coreip.homeip.net>
 <4FFB40A4.5060505@linaro.org>
 <20120709204620.GA12692@core.coreip.homeip.net>
 <4FFB463F.9040201@linaro.org>
 <CACRpkdbjkLvD13_g=TvCUYjqhZ7ySOiEL51h9eT3YVMO4Vnr3A@mail.gmail.com>
 <4FFB4B5F.30103@linaro.org>
 <CACRpkdYJi3Kk3gpdgFLWr+tun4LZNMw0ET6W2nHJfY5jSvgcjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYJi3Kk3gpdgFLWr+tun4LZNMw0ET6W2nHJfY5jSvgcjw@mail.gmail.com>
X-Cookie: Close cover before striking.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 11:08:39PM +0200, Linus Walleij wrote:
> On Mon, Jul 9, 2012 at 11:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> > I did test it, but must have only looked at the one IRQ incrementing.

> That's not enough, cat /dev/input/event/* whatever event node is used
> by the ponkey, press it and verify you get some garbage (=events)
> in the console.

There's the evtest debug program which is very handy for testing input
API stuff (Google should throw up copies, it's just a .c file).
