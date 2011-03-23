Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab1CWULS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:11:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37628 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab1CWULQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:11:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=TCMZIb+45YdOYjA6D/gUpxP7tmrWurRLOA7ZNfdItcLHxz8mlAe6tZvRdJZnnIG8MB
         cl+Mt/9m6TPFylc6cPMSzjnJJy4KrpvzQAW+3OZEIfL7vGV4IUZlRSrnaFDxckc+FASF
         vv6Ioo2onCm4NiQgW9ZJxfZNbjvKMRmI2hBmc=
MIME-Version: 1.0
In-Reply-To: <c4422b4a8ee132d3adac95fd86237c61b2f8b364.1300909446.git.joe@perches.com>
References: <cover.1300909445.git.joe@perches.com>
	<c4422b4a8ee132d3adac95fd86237c61b2f8b364.1300909446.git.joe@perches.com>
Date: Wed, 23 Mar 2011 21:11:15 +0100
X-Google-Sender-Auth: vtBjnoqaKMfNyLbx3zxpSl_DoBU
Message-ID: <AANLkTikOJ4ed+ExLs1Okm2iFrE95SmR1809bT43bzm8X@mail.gmail.com>
Subject: Re: [trivial PATCH 1/2] treewide: Fix iomap resource size miscalculations
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-arm-msm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Joe Perches <joe@perches.com>:

> Convert off-by-1 r->end - r->start to resource_size(r)
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>
(for ux500)

Yours,
Linus Walleij
