Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0HOPs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:48:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38482 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab0HOPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cl/6M0xp3NaKldNE/AtuJn8gbq+ql36qAZHDrJ4DKBU5pq0a2tWh5fZ7ZXrzeGn/hA
         bxuvCZM+24BwSKaON3XDhR4ReEYHysJqMTEdLdRuo+Ij/FyZEfP/dL4hB30+hjJnhHdA
         0tN34kbHksXxVhWpm1O1t/WKyny45Y6eTIN4Y=
MIME-Version: 1.0
In-Reply-To: <1281792661.2718.4.camel@phoenix>
References: <1281792661.2718.4.camel@phoenix>
Date: Sun, 15 Aug 2010 14:01:47 +0200
X-Google-Sender-Auth: V9V8ONrJWrX5tiKiA-vTjNMj-kM
Message-ID: <AANLkTin1b2nqGsb580oT0qH_Lzy6UW+o6P6=JG1DWRjs@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab3100 - fix the logic to remove already
 registered regulators in error path
From: Linus Walleij <linus.walleij@stericsson.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/14 Axel Lin <axel.lin@gmail.com>:
> In current implementation, ab3100_regulators[0].rdev is not unregistered if
> the error happen at i > 0.
>
> This patch fixes the resource leak and also improves the readability.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Great, thanks!

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
