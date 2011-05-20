Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab1ETHrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:47:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50229 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1ETHru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fEIow6AIYs2oqwFNdj73loT/LdE4sKD384xKdvijol5NEqqzdofpJ03ZOdr7E6Dl/Y
         eWkqdLPvGnDbkm3uFghzpm1WAhyLCCR8i0L4brmp5hF4JWi46stbjIW1fGnS/1Xd4aGM
         M8KTNF+0CA+8IgE7aaFPOoasn+eaSvD0r5ut0=
MIME-Version: 1.0
In-Reply-To: <20110520070127.GD21285@ponder.secretlab.ca>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<20110519085638.GA26816@S2100-06.ap.freescale.net>
	<BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
	<20110519135631.GB26816@S2100-06.ap.freescale.net>
	<20110519191156.GE2429@pengutronix.de>
	<20110520070127.GD21285@ponder.secretlab.ca>
Date: Fri, 20 May 2011 09:47:49 +0200
X-Google-Sender-Auth: lhk7d78VEfgkPjIzcEGlN99PtDA
Message-ID: <BANLkTikbh274uE983V=dPiiN27DoafgtTA@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Grant Likely <grant.likely@secretlab.ca>:

> That said, I don't mind moving stuff into drivers/gpio first and
> consolidating it after.

Speaking of which, the topic of the post is not going to be merged
since I did too much in this patch trying to solve all issues at once.

I'll post something much simpler that just moves the U300 and
Nomadik gpio over.

Linus Walleij
