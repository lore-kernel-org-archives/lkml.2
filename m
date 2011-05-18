Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab1ERFbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:31:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63030 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1ERFby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=g4XWtgSEwQ31mHBausmUTCIbLvNqepRm1SXkJQAWt63qfyVtzqcx+cEguwUh5BUhw1
         3WGoPMd7Bwzzvcg26O62w9NK/k+GqS+B/+DAgAF5dJhNqhmNwpiWrPh/aS7mhwMT/BSA
         pgT5E1Q2S3fhUUQSCrPZkRQmUZ5oAH0mmgVxg=
MIME-Version: 1.0
In-Reply-To: <20110516093602.GC17104@pulham.picochip.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
	<20110510235853.GM26703@pulham.picochip.com>
	<BANLkTim5wurV7aFSm4ae6+HBpGZO1z_=XA@mail.gmail.com>
	<20110516093602.GC17104@pulham.picochip.com>
Date: Wed, 18 May 2011 07:31:53 +0200
X-Google-Sender-Auth: vtPBS_CUEcRPGvIgtbq9kTWwX7g
Message-ID: <BANLkTikthHQw_6xA2p9EFrAPNZFLVwwETg@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pinmux subsystem v2
From: Linus Walleij <linus.walleij@linaro.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/16 Jamie Iles <jamie@jamieiles.com>:

> Yes, I think it probably would.  I'm travelling for a bit now so won't
> get chance to try this for a week or two but I'll try porting our
> platform over to this system; it would be great to have a standardized
> way of handling pin muxing.

Sounds like an Acked-by, is it? :-)

I would need ACKs to have this merged...

Yours,
Linus Walleij
