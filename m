Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab0I1JAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:00:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58033 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0I1JAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=b/WfCLqkK5fJCszV9r+iP2l+t1a08Q53b87SEe2NC/rphQgLvSKtaCLZewtsUPlcRL
         Fj3R5tEzhi5eH4Kun3RXYeXhN53YNEkviCKhx3rKZVBrUqspzqNa5sX+bVgeoOKOAuEl
         x+K2VDrfRnvLOZwg7tKH7ov2gnkhJaPrrWbhE=
MIME-Version: 1.0
In-Reply-To: <62697B07E9803846BC582181BD6FB6B835EF64A9AA@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
	<62697B07E9803846BC582181BD6FB6B835EF64A9AA@NOK-EUMSG-02.mgdnok.nokia.com>
Date: Tue, 28 Sep 2010 11:00:20 +0200
Message-ID: <AANLkTi=N-p_ojTt6ia6bLxoA5AKC6rdZky9kvz_BqFqa@mail.gmail.com>
Subject: Re: [PATCH 0/4] Led driver support for LP5521 and LP5523 chips
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: samu.p.onkalo@nokia.com, akpm@osdl.org
Cc: rpurdie@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Persson <martin.persson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/27  <samu.p.onkalo@nokia.com>:

> I haven't got any mails or comments from Richard about this driver.
> Also led tree here:
> http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/
>
> is not updated in 4 months.
>
> I'm just wondering should I send this to somebody else than Richard Purdie?
>
> I'll update the driver based on other comments and send v2 patch set.

We (ST-Ericsson) need this driver in as well.

If Richard is busy maybe Andrew can pick it up for the time being?

Looking forward to the v2 version!

Yours,
Linus Walleij
