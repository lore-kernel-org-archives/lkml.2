Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab2I1PAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:00:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43736 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab2I1O77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:59:59 -0400
Date: Fri, 28 Sep 2012 15:59:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org
Subject: Re: [GIT PULL] MOP500 Audio patches due for ASoC
Message-ID: <20120928145949.GA20786@gmail.com>
References: <1348142956-1872-1-git-send-email-lee.jones@linaro.org>
 <20120920125618.GP17666@opensource.wolfsonmicro.com>
 <20120927150119.GD1176@gmail.com>
 <20120928123743.GE30869@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120928123743.GE30869@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Mark Brown wrote:

> On Thu, Sep 27, 2012 at 04:01:19PM +0100, Lee Jones wrote:
> 
> > Is there any reason why the following patches didn't make it into -next?
> 
> > ASoC: codecs: Enable AB8500 CODEC for Device Tree
> > ASoC: Ux500: Enable ux500 MSP driver for Device Tree
> 
> They appear to be there, there's certainly no reason why they'd be any
> different to the rest of the series.

Okay, I see what's happened. When I rebased the patches I had in my local
delta git just reapplied the commits instead of throwing them out. I can
confirm that the patches above have been applied to -next after all.

Thanks again,
Lee 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
