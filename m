Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2HANU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:20:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab2HANUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:20:25 -0400
Date: Wed, 1 Aug 2012 14:20:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120801132022.GS11892@opensource.wolfsonmicro.com>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
 <1343741493-17671-3-git-send-email-lee.jones@linaro.org>
 <20120731134214.GK4468@opensource.wolfsonmicro.com>
 <5017EAC3.3080504@linaro.org>
 <20120731142820.GW4468@opensource.wolfsonmicro.com>
 <5017EDCA.4020601@linaro.org>
 <20120731145443.GY4468@opensource.wolfsonmicro.com>
 <5017F68B.3060400@linaro.org>
 <20120731151819.GC4468@opensource.wolfsonmicro.com>
 <5018D880.5090306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5018D880.5090306@linaro.org>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:19:28AM +0100, Lee Jones wrote:
> On 31/07/12 16:18, Mark Brown wrote:

> >I'm not going to apply this patch.  This isn't a vendor BSP, we
> >shouldn't be putting random hacks like this in core code.

> BSP kernel or otherwise, it still seems wrong to me to fail and
> entire audio driver just because of a broken link.

No, really.  Random disconnections in the DAPM graph are just endless
pain from a support and debug point of view.  This isn't something that
randomly breaks on specific hardware where we'd expect random errors at
runtime, it's something that will never have worked - it seems clear
nobody tested the mainline submission.

It's very disappointing to see such an error exist, and even more
disappointing that there's no interest in fixing the driver.
