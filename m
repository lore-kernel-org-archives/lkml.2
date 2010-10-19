Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0JSPJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:09:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53864 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0JSPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iM4RZM1qjJ/JbMk8ykSAsQyocYNHlr70JfjFu3AsGB8p7FEIjslllNWZSgOZp/92ZX
         4bSpfQMHWnsxOp3R26XAbxRrFpb+R8qkRTszucEBHQQbh4hQoq23473b9sJn2Afb6E2B
         eRMywyc9rPU6im40xjQNgZY+/YL5NnMenU8/c=
MIME-Version: 1.0
In-Reply-To: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 19 Oct 2010 17:09:46 +0200
Message-ID: <AANLkTim6vq7dPjTt4GzB6JyEDfL50H67gMacw5UbWRAm@mail.gmail.com>
Subject: Re: [PATCH 0/7] ste_dma40: various fixes to the DMA40
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/12 Linus Walleij <linus.walleij@stericsson.com>:

> here are some DMA40 cleanups for your immediate entertainment,
> mostly tightening up this driver. It is getting real mature
> now, still we need fix some smallish things...

Dan are you taking these for the upcoming merge window?
Since they change the platform data API a bit it'd be nice to
have them in.

Yours,
Linus Walleij
