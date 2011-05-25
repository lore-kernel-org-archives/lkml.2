Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1EYJHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:07:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50300 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1EYJHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JNR5fC7WRDBqKg4v/R/DsCNtSiGGJa8EgBCQDB3BFCi+PmyoGNUwhYWVy4jjdAP0II
         F4jmIW7lnc0SjqkkfK2jUm9AmADHbKS0es6XN4daclh/REm7DtAgZmzh1yzo742sdaQT
         r/qVuzLrsbIojjEKqOpqCTcgK6b7PmXVvCWgU=
MIME-Version: 1.0
In-Reply-To: <4DDBC8C7.4000001@gmail.com>
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com>
	<20110519233958.GB18181@ponder.secretlab.ca>
	<4DD66B8A.5040404@gmail.com>
	<201105201621.03801.arnd@arndb.de>
	<4DD68614.6090209@gmail.com>
	<a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local>
	<BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
	<4DDA2AC0.1060406@gaisler.com>
	<20110523095829.GG17672@n2100.arm.linux.org.uk>
	<BANLkTink1rrC8F3Gjhqt84gYzOibX+AgDQ@mail.gmail.com>
	<4DDBC8C7.4000001@gmail.com>
Date: Wed, 25 May 2011 11:07:18 +0200
X-Google-Sender-Auth: f0-z9_BdYYDdbrmWJTU5xQdV1r0
Message-ID: <BANLkTin4xKHbxysxN8M-5AP2143VkoLG=g@mail.gmail.com>
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/24 Rob Herring <robherring2@gmail.com>:

> I think having "arm,amba-deviceid" is not needed. The current code does
> nothing but warn if it doesn't match the h/w value. The drivers already have
> a list of id's that they support and the amba bus only matches against the
> h/w id value. The only use I can see is overriding a broken h/w value.

We have this usecase in the Ux500. See these patches:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6829/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6830/1

Alas, it's not yet merged for the old boardfile world usecase, and
causing us problems to drive our hardware already.

Yours,
Linus Walleij
