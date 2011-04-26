Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab1DZHsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:48:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59414 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab1DZHsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uhvvulAc86iOUl/8MNH5iec3TRQJM4Z/EMQPhS+Xl5ZxfZG33kcWQrhoyHuK83b6Wf
         SlJiUgYphHf3vA/bXUSgEHvDJKJ0woBAWaBjJ1nSDGZOXYoQoPMs2exDSFwKQ25Jhjde
         9r4EdAvzw1Vr9lsvWuFEOGcDyUlH8tTS20/pg=
MIME-Version: 1.0
In-Reply-To: <4DB5C307.1060507@codeaurora.org>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<4DB5C307.1060507@codeaurora.org>
Date: Tue, 26 Apr 2011 09:48:02 +0200
X-Google-Sender-Auth: BLY8buH8tydXLeX309nSDpzZXQE
Message-ID: <BANLkTikvzghJ3Ey82mWiMU3T28VC8WuAtA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/25 Rohit Vaswani <rvaswani@codeaurora.org>:

> Another API to select this would make it more powerful. At boot a lot of
> gpios are configured by the board-file.

Yeah I have already revised this patchset...

> How do you feel about another API that can accepts the gpio config
> parameters (void *data) and set them all at once?
> This would make it more generic to suit different gpio parameters that an
> arch might have.

It's done that way now, and as Alan noted it fits hand-in-glove with
devicetree initialization that way too.

Yours,
Linus Walleij
