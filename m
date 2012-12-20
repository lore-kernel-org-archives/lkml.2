Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab2LTHv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 02:51:28 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:40504 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2LTHvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 02:51:21 -0500
Date: Thu, 20 Dec 2012 07:51:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/21] gpio: ab8500: Bring AB8500 back to life
Message-ID: <20121220075117.GE2691@gmail.com>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdatZTFNFKL+8+EPkj0yRX8HSnwUu44dXrrWL1VBRPmwrA@mail.gmail.com>
 <20121219224937.E3C683E0AD6@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121219224937.E3C683E0AD6@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012, Grant Likely wrote:

> On Wed, 19 Dec 2012 15:18:00 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Fri, Dec 14, 2012 at 5:19 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > The ab8500 GPIO driver is currently 'BROKEN', due to a lack of
> > > updates and recent frame-work adoption. This patch-set aims to
> > > bring the driver back to life so we may make use of it again.
> > >
> > > This first stage is to bring it into line with ST-Ericsson's
> > > internal track, which has been keeping up-to-date. After these
> > > patches have been accepted I will then overhaul the driver to
> > > use the most recent APIs and frame-works, such as pinctrl and
> > > Device Tree.
> > >
> > > Please give these patches an easy ride. I know they're not
> > > perfect, but they do provide a great base on with I can form
> > > the overhaul. Thanks for your understanding.
> > 
> > OK I've applied these 21 patches on a branch in the pinctrl
> > tree to be used as a merge base.
> > 
> > The only valid reason to have it in the pinctrl tree is obviously
> > that it should be converted into a pinctrl driver in the next
> > cycle, aiming at includion into kernel v3.9.
> > 
> > I know my colleague Patrice is already working on this, and
> > thus I can plan for it :-) It is also an interesting subject since
> > the ux500 will be the first platform with two pin controllers
> > and the first with an off-SoC pin controller.
> 
> Okay, fine by me. I've looked through all the patches and I think they
> should be merged.

Thanks for your understanding Grant.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
