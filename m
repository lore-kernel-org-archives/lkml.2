Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab2LSWtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:49:49 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60790 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2LSWtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:49:42 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/21] gpio: ab8500: Bring AB8500 back to life
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CACRpkdatZTFNFKL+8+EPkj0yRX8HSnwUu44dXrrWL1VBRPmwrA@mail.gmail.com>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org> <CACRpkdatZTFNFKL+8+EPkj0yRX8HSnwUu44dXrrWL1VBRPmwrA@mail.gmail.com>
Date: Wed, 19 Dec 2012 22:49:37 +0000
Message-Id: <20121219224937.E3C683E0AD6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 15:18:00 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Dec 14, 2012 at 5:19 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The ab8500 GPIO driver is currently 'BROKEN', due to a lack of
> > updates and recent frame-work adoption. This patch-set aims to
> > bring the driver back to life so we may make use of it again.
> >
> > This first stage is to bring it into line with ST-Ericsson's
> > internal track, which has been keeping up-to-date. After these
> > patches have been accepted I will then overhaul the driver to
> > use the most recent APIs and frame-works, such as pinctrl and
> > Device Tree.
> >
> > Please give these patches an easy ride. I know they're not
> > perfect, but they do provide a great base on with I can form
> > the overhaul. Thanks for your understanding.
> 
> OK I've applied these 21 patches on a branch in the pinctrl
> tree to be used as a merge base.
> 
> The only valid reason to have it in the pinctrl tree is obviously
> that it should be converted into a pinctrl driver in the next
> cycle, aiming at includion into kernel v3.9.
> 
> I know my colleague Patrice is already working on this, and
> thus I can plan for it :-) It is also an interesting subject since
> the ux500 will be the first platform with two pin controllers
> and the first with an off-SoC pin controller.

Okay, fine by me. I've looked through all the patches and I think they
should be merged.

g.
