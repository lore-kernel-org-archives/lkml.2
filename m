Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2FUICc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:02:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60918 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2FUIC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:02:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FE1F918.1040909@wwwdotorg.org>
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
	<CACRpkdYSLiLZwVwY1tU9PWGTx2EGP6OykeXE5rtwRKAHror-Yg@mail.gmail.com>
	<20120620100058.GD3978@opensource.wolfsonmicro.com>
	<4FE1F918.1040909@wwwdotorg.org>
Date: Thu, 21 Jun 2012 10:02:26 +0200
Message-ID: <CACRpkdZbGJ0fiNuYvU-07DuwJrCugTNOyE_ppVWfk4Asf3nCiA@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] regulator: dt: add policy to match regulator with
 prop "regulator-compatible"
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>, grant.likely@secretlab.ca
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        arnd@arndb.de, lrg@ti.com, lee.jones@linaro.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 6:23 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Related to this, I wonder if we need some scheme to tag individual
> bindings as under-development vs. final, and some way to promote
> bindings between those states (a bindings review board?!).

Hm, we just have Documentation/devicetree/bindings and that's it.

But compare to the Documentation/ABI:
$ ls
obsolete  README  removed  stable  testing

I think we might want to mirror this structure for the
bindings, putting all current bindings into testing.

That said, this scheme has not always been very strictly
enforced on sysfs etc. But the ambition is there.

Yours,
Linus Walleij
