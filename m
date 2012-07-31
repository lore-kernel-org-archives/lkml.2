Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2GaPSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:18:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60691 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874Ab2GaPSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:18:22 -0400
Date: Tue, 31 Jul 2012 16:18:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120731151819.GC4468@opensource.wolfsonmicro.com>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
 <1343741493-17671-3-git-send-email-lee.jones@linaro.org>
 <20120731134214.GK4468@opensource.wolfsonmicro.com>
 <5017EAC3.3080504@linaro.org>
 <20120731142820.GW4468@opensource.wolfsonmicro.com>
 <5017EDCA.4020601@linaro.org>
 <20120731145443.GY4468@opensource.wolfsonmicro.com>
 <5017F68B.3060400@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5017F68B.3060400@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 04:15:23PM +0100, Lee Jones wrote:
> On 31/07/12 15:54, Mark Brown wrote:

> >You might want to look at a better mail program.

> Willingly. Any good suggestions?

mutt works for me.

> >It's certainly totally inappropriate for an "urgent" bugfix.

> Well it just means that audio won't work for the ux500 for this
> kernel release, but as we're waiting on clocks, this isn't a big
> issue for us. If you do take it (with or without the return code),
> feel free to add it to for-next instead of the -rc:s

I'm not going to apply this patch.  This isn't a vendor BSP, we
shouldn't be putting random hacks like this in core code.
