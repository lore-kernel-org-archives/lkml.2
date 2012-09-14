Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab2INJhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:37:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34606 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2INJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:37:23 -0400
Date: Fri, 14 Sep 2012 10:37:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 01/19] ARM: ux500: Add skeleton Device Tree for the HREF
 reference board
Message-ID: <20120914093715.GM3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-2-git-send-email-lee.jones@linaro.org>
 <CACRpkdbWVjiqrehj_v7M=cgnytEio5whTXOcax5wo0YSRe=-yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbWVjiqrehj_v7M=cgnytEio5whTXOcax5wo0YSRe=-yA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 01:47:09AM -0700, Linus Walleij wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > First commit applying the new Device Tree for ST-Ericsson's u8500
> > based hardware reference board.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> > +/dts-v1/;
> > +/include/ "dbx5x0.dtsi"
> 
> This include is not even in linux-next, is this patch series dependent
> on some other series I have not seen, or that I have forgot that
> I saw (and even possibly ACKed...)

Yes, all of the above.

I have them all here locally. Will test push something today hopefully.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
