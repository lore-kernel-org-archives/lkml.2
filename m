Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1KXPSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:18:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47544 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab1KXPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:18:19 -0500
Date: Thu, 24 Nov 2011 15:18:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH v2] pinctrl: add a generic pin config interface
Message-ID: <20111124151812.GN8470@opensource.wolfsonmicro.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
 <CACRpkdYh7+kL-9iy7+VDC82OAkb+-vLiJcv02pappaTeDUriTg@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74FD9@HQMAIL01.nvidia.com>
 <CACRpkdaDeK3A-o775LGR9qOSGKkiQtDBuLvadw1zL26E6BgOSQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF174F08C2A5@HQMAIL01.nvidia.com>
 <20111122135922.GA3837@opensource.wolfsonmicro.com>
 <CACRpkdb78AAM-9JasxQ2pRLwVGj0n64bqo82oVbpaFKsMNqnaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb78AAM-9JasxQ2pRLwVGj0n64bqo82oVbpaFKsMNqnaA@mail.gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 03:19:39PM +0100, Linus Walleij wrote:
> On Tue, Nov 22, 2011 at 2:59 PM, Mark Brown

> > I'd second this - in my experience detailed setup for these settings
> > usually comes from hardware engineers in the form of "set register X to
> > value Y".  Having to decode the sematics does make things that little
> > bit harder.

> I'm a bit reluctant, since the above is sometimes referred to as
> "throw over the wall engineering" and is generally considered a bad
> way of doing things.

Well, another way of describing the above situation would be the
software engineers going to the hardware engineer and saying that
they've got ringing on a signal (or something) and the hardware
engineer coming back with a suggested fix.
