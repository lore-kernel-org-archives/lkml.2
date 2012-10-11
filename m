Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2JKH3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:29:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55192 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2JKH3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:29:32 -0400
Date: Thu, 11 Oct 2012 08:29:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [PATCH 4/6] ARM: ux500: Add UART support to the u9540 Device Tree
Message-ID: <20121011072927.GR9707@gmail.com>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
 <1349882335-6786-5-git-send-email-lee.jones@linaro.org>
 <20121010190325.GT12801@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121010190325.GT12801@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 16:18 Wed 10 Oct     , Lee Jones wrote:
> > Add the 3 UART nodes required to enable serial ports on the u9540.
> > 
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/u9540.dts |   13 ++++++++++++-
> dts? it's dtsi

No it's not.

> it's the soc not the board

This is the board file, not the SoC.

> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/u9540.dts b/arch/arm/boot/dts/u9540.dts
> > index 0a66f34..28efe20 100644
> > --- a/arch/arm/boot/dts/u9540.dts
> > +++ b/arch/arm/boot/dts/u9540.dts
> > @@ -21,6 +21,17 @@
> >  	};
> >  
> >  	soc-u9500 {
> > -	};
> >  
> > +		uart@80120000 {
> > +			status = "okay";
> > +		};
> > +
> > +		uart@80121000 {
> > +			status = "okay";
> > +		};
> > +
> > +		uart@80007000 {
> > +			status = "okay";
> > +		};
> do not enable device by default in the soc

See above.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
