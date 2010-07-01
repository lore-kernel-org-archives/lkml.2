Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0GAJBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:01:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49854 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab0GAJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=W+Po1uCEDzAvVpRltXe4INTPSd6yAuG91U1LstAkj7X1NzAA5/abdBCsbDRaJ2hpLU
         UqYZHq/Nu4eaS0jUW7kCIbw2TC8TUrz6NTf5FzguGRorN24K/gzGCNeIyzpTlp2nIwfC
         rYi8whOuJx98FAOdgQM+NOo+qWSLSSPV9RmH4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikbk4zoFQfunWz1yQ7d2tYhm4illg6CyeOnVkDk@mail.gmail.com>
References: <1277069076-30579-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTikbk4zoFQfunWz1yQ7d2tYhm4illg6CyeOnVkDk@mail.gmail.com>
Date: Thu, 1 Jul 2010 02:01:06 -0700
X-Google-Sender-Auth: 2Ka0_b8TKJqvsk5papMS1ThpokQ
Message-ID: <AANLkTin6lOBwDkQEDjknhDwCKOkBhO9Nqv_OrG4Ira53@mail.gmail.com>
Subject: Re: [PATCH 00/19] DMAENGINE: ste_dma40: bugfixes v2
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 1:20 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> Hi Dan, can these fixes go in now? I'd like to base
> the new patches for channel control and PrimeCells on
> top of these so it doesn't stack up...

Pressure should be relieved now... it's pushed out to -next, sorry for
the delay.

--
Dan
