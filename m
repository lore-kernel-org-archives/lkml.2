Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2INJKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:10:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36387 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab2INJKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:10:44 -0400
Date: Fri, 14 Sep 2012 10:10:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 10/19] ARM: ux500: Remove redundant #gpio-cell properties
 from HREF and Snowball DT
Message-ID: <20120914091037.GI3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-11-git-send-email-lee.jones@linaro.org>
 <CACRpkdY_gyWRO20ZOfTmG=tzE_B3ObWZG_4f8gHS6vyiGZSh6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY_gyWRO20ZOfTmG=tzE_B3ObWZG_4f8gHS6vyiGZSh6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 04:12:23AM -0700, Linus Walleij wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > These properties have no place here as the populated nodes are
> > not related to GPIO Controllers.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Squash this into the previous patch adding them...
> I think Arnd already noted.

Well he noted that I'd duplicated the error from the snowball.dts
file, then rectified in this patch, which is fair enough. However,
I don't think the snowball.dts fix should be squashed into an HREF
enablement patch, and I can't find a suitable patch in the patch-
set where it would really fit. Should I leave the Snowball fix
separate and just fixup the HREF .dts file to never duplicate the
anomaly?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
