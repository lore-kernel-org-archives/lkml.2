Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab2DGBwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:52:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43180 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2DGBwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:52:02 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv3 3/3] misc: add support for bmp18x chips to the bmp085 driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com, stefan.nilsson@unixphere.com,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20120404201116.GC10787@opensource.wolfsonmicro.com>
References: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com> <1333568759-13536-4-git-send-email-eric.andersson@unixphere.com> <20120404195532.GB10787@opensource.wolfsonmicro.com> <201204042000.34160.arnd@arndb.de> <20120404201116.GC10787@opensource.wolfsonmicro.com>
Date: Fri, 06 Apr 2012 18:37:51 -0700
Message-Id: <20120407013751.294C13E2187@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012 21:11:17 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Apr 04, 2012 at 08:00:33PM +0000, Arnd Bergmann wrote:
> > On Wednesday 04 April 2012, Mark Brown wrote:
> > > > +static const struct of_device_id bmp085_of_match[] = {
> > > > +     { .compatible = "bosch-sensortec,bmp085", },
> 
> > > Traditionally the stock ticker symbol would be used.
> 
> > I though about commenting on that as well, but since Bosch is a foundation
> > and not publically traded, that would be hard to accomplish. Is there
> > an official fallback for companies that don't have a stock ticker symbol?
> 
> Guess we should ask the DT people...  I mostly just noticed that the
> name appeared somewhat verbose - perhaps just plain "bosch" if there's
> not a better abbrevation?

*MY* official fallback is go with whatever is documented in
Documentation/devicetree/bindings/vendor-prefixes.txt.  If the needed
value isn't there, then add it!  :-)

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
