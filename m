Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2AWTT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:19:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47359 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab2AWTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:19:28 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812C6D0D3@EXMAIL03.scwf.nsc.com>
References: <AczXFgV8f/jdU5qUSd6MQcwmtcr9IA==>
	<B567DBAB974C0544994013492B949F8E3812C6D0D3@EXMAIL03.scwf.nsc.com>
Date: Mon, 23 Jan 2012 20:19:28 +0100
Message-ID: <CACRpkdYLfNOdRsFpo8u4u_X0obAeuYtvt8bkcyCQ536tw86RyQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] leds-lm3530: replace 'pltfm' with 'pdata'
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 2:51 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> Use 'pdata' rather than 'pltfm' in lm3530_init_registers().
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

You're ringht this is a more common naming.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

...but it won't apply because i NACKed the regulator avoidance
patch... so it'll need updating.

Yours,
Linus Walleij
