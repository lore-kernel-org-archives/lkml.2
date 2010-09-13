Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab0IMOzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:55:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46174 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0IMOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k4NtdMVG3fK0K+bMFLznss8BMcc0L5DO06DrBrnK3hXrUmqJBtoWoibu6GmVu6cLUL
         XvrLymzXeS6iKbkmjRyT5sTKu4ocWU2/NhOL9pH+MxUVvymSyJXiTmrX+i+s9fd81n3A
         blUe5jI0BjwH2H7LgZU4gUA9lHNpMwk4Iwv9Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTimNnA=tNCE7pLiibwB66R86dNmCDpCuQMkTvw9J@mail.gmail.com>
References: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
	<1284135579-13578-6-git-send-email-wellsk40@gmail.com>
	<AANLkTimNnA=tNCE7pLiibwB66R86dNmCDpCuQMkTvw9J@mail.gmail.com>
Date: Mon, 13 Sep 2010 16:55:43 +0200
Message-ID: <AANLkTi=pKmP-G8aA4a96KhyNSKcaKrm9S5rnSw-0UyFo@mail.gmail.com>
Subject: Re: [PATCH 5/5] spi: amba_pl022: Remove unused fields from pl022_config_chip
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: wellsk40@gmail.com
Cc: spi-devel-general@lists.sourceforge.net, sameo@linux.intel.com,
        rabin.vincent@stericsson.com, srinidhi.kasagar@stericsson.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        tj@kernel.org, grant.likely@secretlab.ca, Lukasz.Baj@tieto.com,
        quentinyang05@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/13 Linus Walleij <linus.ml.walleij@gmail.com>:

> I think you have to do a more thorough patch:

No, wait it's me. I have to have the old patch first and then this
on top, sorry.

I'll test again...

Linus
