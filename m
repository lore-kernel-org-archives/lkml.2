Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2INIrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:47:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64465 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2INIri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:47:38 -0400
Date: Fri, 14 Sep 2012 09:47:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 11/19] ARM: ux500: Add all known I2C sub-device nodes to
 the HREF DT
Message-ID: <20120914084729.GG3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-12-git-send-email-lee.jones@linaro.org>
 <CACRpkdY+t9MwWewtZzpD7i4eeTxVHNk+NxSZ1E=T-k4a0mveHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY+t9MwWewtZzpD7i4eeTxVHNk+NxSZ1E=T-k4a0mveHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 04:34:15AM -0700, Linus Walleij wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Here we add the skeleton nodes for each of the known I2C sub-devices
> > currently registered on ST-Ericsson's HREF Development Platform. We
> > will fill these nodes in turn as the drivers are enabled for Device
> > Tree.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Can't we have it the other way around (discussing patch ordering
> with Arnd simultaneously), so you first add the DT support to the
> subdevices, then add the more complete nodes to the device tree?
> 
> And if you put in a device tree like this, will these devices
> not collide with the ones that are currently supplied from
> the boardfiles? I'm a bit confused here, maybe I'm not smart
> enough to understand this...

Okay, I've reordered the patch-set to address these possible issues.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
