Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab2KWJMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:12:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61157 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab2KWJMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:12:41 -0500
Date: Fri, 23 Nov 2012 09:12:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ola Lilja <ola.o.lilja@stericsson.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [RESENDING] [PATCH 07/22] ASoC: Ux500: Initialise PCM from MSP
 probe rather than as a device
Message-ID: <20121123091236.GA17471@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-8-git-send-email-lee.jones@linaro.org>
 <CACRpkdbc6bGC4Yp7Bcdfev=Uc=1h4L1v+Lj9RbmJV3F+knQOZQ@mail.gmail.com>
 <20120919133343.GH25694@gmail.com>
 <505ADBE6.6080509@stericsson.com>
 <20120920125259.GA2755@gmail.com>
 <20121122140540.GA10986@gmail.com>
 <20121123015838.GH4385@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121123015838.GH4385@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Mark Brown wrote:

> On Thu, Nov 22, 2012 at 02:05:40PM +0000, Lee Jones wrote:
> > On Thu, 20 Sep 2012, Lee Jones wrote:
> 
> > > > > Can we have some closure on this patch please, as it's blocking the
> > > > > patch-set? I'm fairly sure the patch is doing the correct thing, as
> > > > > seconded by Mark.
> 
> > > > I still don't like this. It is the dai_link-struct that bothers me. We have
> > > > "ux500-msp-i2s.1" as name of the platform AND the cpu_dai. The MSP I2S-block is
> > > > not the platform and it is certainly not both platform and cpu-DAI at the same time.
> > > > Mark: Did you have a solution for this? Couldn't we just put NULL on the
> > > > platform_name instead?
> 
> > > There are other drivers which do this already. 
> 
> > > I don't think it's an issue to do this.
> 
> > Has anyone had any more bright ideas on how we might handle this?
> 
> > The device is still being handled in platform code and I'm desperate
> > to get it out of there.
> 
> Why do we need any ideas?  Just implement it already.

How do you mean? I've written the patch, just accept it. ;)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
