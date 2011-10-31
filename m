Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548Ab1JaPui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:50:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab1JaPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <20111029110613.GE20132@ponder.secretlab.ca>
References: <1319833142-4764-1-git-send-email-linus.walleij@linaro.org>
	<20111029110613.GE20132@ponder.secretlab.ca>
Date: Mon, 31 Oct 2011 16:50:37 +0100
Message-ID: <CACRpkdaVWSG+it=pJhYeS043ocsogbG+rC+nxR0grgeGfgfFjw@mail.gmail.com>
Subject: Re: [PATCH] ARM: mark empty gpio.h files empty
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, Jeff Garzik <jeff@garzik.org>,
        linux-kernel@vger.kernel.org, swarren@nvidia.com, olof@lixom.net,
        ben@decadent.org.uk, arnaud.patard@rtp-net.org, w.sang@pengutronix.de,
        bs14@csr.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 1:06 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Oct 28, 2011 at 10:19:02PM +0200, Linus Walleij wrote:
>> It is generally a better idea to make intentionally empty files
>> contain the human-readable /* empty */ comment, also it makes
>> the files play nice with "make distclean".
>>
>> Reported-by: Jeff Garzik <jeff@garzik.org>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Applied, thanks.

Hm I put that into Russell's patch tracker since it was mainly
touching arch/arm/*
and I think he applied it too.

Well whatever, git will cope.

Yours,
Linus Walleij
