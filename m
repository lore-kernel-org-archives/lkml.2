Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab2IGMj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:39:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56580 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2IGMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:39:27 -0400
Date: Fri, 7 Sep 2012 13:39:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com
Subject: Re: [PATCH 04/19] ARM: ux500: Add SDI (MMC) support to the HREF
 Device Tree
Message-ID: <20120907123922.GC29601@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-5-git-send-email-lee.jones@linaro.org>
 <201209071229.32027.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201209071229.32027.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 12:29:31PM +0000, Arnd Bergmann wrote:
> On Friday 07 September 2012, Lee Jones wrote:
> > +               // External Micro SD slot
> > +               sdi@80126000 {
> > +                       arm,primecell-periphid = <0x10480180>;
> > +                       max-frequency = <50000000>;
> > +                       bus-width = <8>;
> > +                       mmc-cap-sd-highspeed;
> > +                       mmc-cap-mmc-highspeed;
> > +                       vmmc-supply = <&ab8500_ldo_aux3_reg>;
> > +
> > +                       #gpio-cells = <1>;
> > +                       cd-gpios  = <&gpio2 31 0x4>; // 95
> > +
> > +                       status = "okay";
> > +               };
> > +
> 
> The #gpio-cells property seems misplaced here.

Are you reading my patches in reverse order? ;)

If not, good spot. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
