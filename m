Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab1FWKyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:54:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38234 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157Ab1FWKyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=KwBrUMJJDjgaDpIri9tteZGJF+OYXEnlfamm51qxVx7BRzlrbIJHP01adVfBs0j9Ui
         fw5F2v5AvZS5f4HWVz9cgRzk5a5N+vAuSGlOcBokrwZ68Xh4OfyMDKgtaXjibnQFJx6z
         gIy/5GgEjpCBPwlecYrl2BXxEBV1SIX2b+6j4=
MIME-Version: 1.0
In-Reply-To: <1307695731-28018-1-git-send-email-linus.walleij@stericsson.com>
References: <1307695731-28018-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 23 Jun 2011 12:54:39 +0200
X-Google-Sender-Auth: rLEbYh6RymKsvepmNO_qnx06M3U
Message-ID: <BANLkTimQxHHkf4c9mQS-UEa5vU8A=yXchA@mail.gmail.com>
Subject: Re: [PATCH 0/2] RFC: gpio: driver-local pin configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Kyungmin Park <kmpark@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ben Nizette <bn@niasdigital.com>, Stijn Devriendt <highguy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Linus Walleij <linus.walleij@stericsson.com>:

> in this patch set I expose gpio_to_chip(), then alter the
> previous rewrite of the U300 GPIO driver to instead use a local
> configuration function (...)

Any feedback on this?

Good? Bad? Linus (W) is an idiot?

Any third path to doing custom config?

Thanks,
Linus Walleij
