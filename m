Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab2GNUv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:51:56 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42697 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab2GNUvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:51:45 -0400
MIME-Version: 1.0
In-Reply-To: <87a9z4g9bi.fsf@ti.com>
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
	<1341997995-14020-3-git-send-email-tarun.kanti@ti.com>
	<87394xhocn.fsf@ti.com>
	<CACRpkdZMG_ZHW_eGGrdrJh1SuO_=hOObijzmxG1ob6RoNf_dwg@mail.gmail.com>
	<87a9z4g9bi.fsf@ti.com>
Date: Sat, 14 Jul 2012 22:51:44 +0200
Message-ID: <CACRpkdZxUpQ=a-yQ8b4bnX3S9penPWkxJ+PG2Zi4i9YZibYRiw@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio/omap: add *remove* callback in platform_driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Hilman <khilman@ti.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 7:48 PM, Kevin Hilman <khilman@ti.com> wrote:

> In the case of OMAP GPIO, unless it's an obvious fix, I would recommend
> you wait at least until you see some acks/tested tags from any of
>
> - Santosh Shilimkar <santosh.shilimkar@ti.com>
> - Rajendra Nayak <rnayak@ti.com>
> - Benoit Cousson <b-cousson@ti.com>
>
> or Tony, Paul or myself.

Instead of trying to store this information in my and Grants brains and
us forgetting it, what about patching MAINTAINERS to reflect the fact
instead? That's better I think, plus I use that file a lot.

> For major series, I have been collecting/queueing them for Grant after
> ensuring they have been well reviewed and well tested (although I am
> eagerly hoping to hand off this role to someone else.)

Listing it under your GIT tree in MAINTAINERS for this driver will make
this work better I think.

One path for OMAP GPIO patches, simple. It's obviously the
ambiguity that cause the trouble. Then you can also decide
on each cycle whether to send these to GPIO or ARM SoC
etc.

Yours,
Linus Walleij
