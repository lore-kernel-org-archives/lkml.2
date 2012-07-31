Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2GaOyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:54:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41041 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab2GaOyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:54:46 -0400
Date: Tue, 31 Jul 2012 15:54:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120731145443.GY4468@opensource.wolfsonmicro.com>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
 <1343741493-17671-3-git-send-email-lee.jones@linaro.org>
 <20120731134214.GK4468@opensource.wolfsonmicro.com>
 <5017EAC3.3080504@linaro.org>
 <20120731142820.GW4468@opensource.wolfsonmicro.com>
 <5017EDCA.4020601@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5017EDCA.4020601@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:38:02PM +0100, Lee Jones wrote:

> Neither of those are in my Inbox. Blame Mozilla. :)

You might want to look at a better mail program.

> It's better because the whole audio system doesn't fail in the case
> of minor failure. It'd be like calling off a football game (or
> whatever you're into) because one of the substitutes ruptured an
> eyelash.

It shouldn't make any difference to startup - we should still be
checking errors and failing the init if we're failing to add links, 
this isn't something that's likely to randomly break on a particular
boot, it's more something that indicates nobody bothered testing.

It's certainly totally inappropriate for an "urgent" bugfix.

> During start-up the ux500 has a couple of very unimportant widgets
> fail. It's the wrong behavior to force failure on the everything
> audio just because of that.

Fixes for those errors, however...
