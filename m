Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2LSOX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:23:28 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:50116 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2LSOXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:23:23 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 09:23:22 EST
MIME-Version: 1.0
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 19 Dec 2012 15:18:00 +0100
Message-ID: <CACRpkdatZTFNFKL+8+EPkj0yRX8HSnwUu44dXrrWL1VBRPmwrA@mail.gmail.com>
Subject: Re: [PATCH 00/21] gpio: ab8500: Bring AB8500 back to life
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Patrice CHOTARD <patrice.chotard@st.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 5:19 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The ab8500 GPIO driver is currently 'BROKEN', due to a lack of
> updates and recent frame-work adoption. This patch-set aims to
> bring the driver back to life so we may make use of it again.
>
> This first stage is to bring it into line with ST-Ericsson's
> internal track, which has been keeping up-to-date. After these
> patches have been accepted I will then overhaul the driver to
> use the most recent APIs and frame-works, such as pinctrl and
> Device Tree.
>
> Please give these patches an easy ride. I know they're not
> perfect, but they do provide a great base on with I can form
> the overhaul. Thanks for your understanding.

OK I've applied these 21 patches on a branch in the pinctrl
tree to be used as a merge base.

The only valid reason to have it in the pinctrl tree is obviously
that it should be converted into a pinctrl driver in the next
cycle, aiming at includion into kernel v3.9.

I know my colleague Patrice is already working on this, and
thus I can plan for it :-) It is also an interesting subject since
the ux500 will be the first platform with two pin controllers
and the first with an off-SoC pin controller.

But any cleanups are welcome now, and I know you're already
up to more patching...

Let us make sure we chisel out a real nice pinctrl/pinctrl-abx500.c
driver by the end of this kernel cycle so things are under
(pin)control again.

Yours,
Linus Walleij
