Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0IWHqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 03:46:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50704 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0IWHqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 03:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OVsmwvUBmERfG3m1QmDjsg+7j9V/b0n0vtjgHbLi6XuBwMiirxuWwgNutLDcShpTGf
         6aW4+QTZA+RwuGwfMjTs5IPG9yEyz/WNF7EfFBW/oLJjncMMbd8/q2iGhXhvkGsYAkay
         cFY56Rl23EsPXO4WXpA4CZQO/RBsgeHVQqwgw=
MIME-Version: 1.0
In-Reply-To: <AANLkTimGu1R0vqpLK9X30CxkibO6N964D1Y-fQvAdA9D@mail.gmail.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-3-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-4-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-5-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-6-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-7-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-8-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-9-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-10-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-11-git-send-email-linus.walleij@stericsson.com>
	<1283256734-3408-12-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimGu1R0vqpLK9X30CxkibO6N964D1Y-fQvAdA9D@mail.gmail.com>
Date: Thu, 23 Sep 2010 09:46:36 +0200
Message-ID: <AANLkTi=7gsXT2P-7a=DCTsaUBK=B131VFFCBzNVzpYFv@mail.gmail.com>
Subject: Re: [PATCH 11/12] DMAENGINE: let PL08X memcpy TXDs wait
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Per_Frid=E9n?= <per.friden@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/23 Dan Williams <dan.j.williams@intel.com>:

> The prep routine is meant to guarantee that all the resources for a
> transaction have been acquired.

A practicality here:

The assumption to fail for physical channel allocation at .tx_submit()
is already in the first patch adding the driver.

Should I squash all the icremental improvements into the original
driver, convert to fail at .prep() and resubmit to make all of this
easier, or do you want me to refactor the patch stack, or refactor
from patch 11/12 or...?

Yours,
Linus Walleij
