Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab1CWUH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:07:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37478 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab1CWUH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Zw0uMRxHyL01YSX5ljPHJBnphRNxDmkcVL0YO3qxUajw7HXkkp5IR20YilwpJCYs5B
         0S5ZADmnniKcwwnFCT6WmH9ZNfzE1LV3vuz7BJAHON5RwKddjH6v+QUYm3oRKspPxOfh
         ZiY+xRdHRdG6TagIto1VoXqzEnrlgdgyiImR8=
MIME-Version: 1.0
In-Reply-To: <798d0aea7272beadf2ee838f7aa27f86cfe7f9ba.1300909446.git.joe@perches.com>
References: <cover.1300909445.git.joe@perches.com>
	<798d0aea7272beadf2ee838f7aa27f86cfe7f9ba.1300909446.git.joe@perches.com>
Date: Wed, 23 Mar 2011 21:07:27 +0100
X-Google-Sender-Auth: IHvF6aRcjHyBbhKgiGeclcLNPdc
Message-ID: <AANLkTika-y8bqaXFp008C28wd_YzmcBm2mj5ZLfxSSSy@mail.gmail.com>
Subject: Re: [trivial PATCH 2/2] arm: mach-u300/gpio: Fix mem_region resource
 size miscalculations
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Joe Perches <joe@perches.com>:

> Convert off-by-1 r->end - r->start to resource_size(r)
>
> Signed-off-by: Joe Perches <joe@perches.com>

Oh man, there was one of these lurking in my own beloved mach-u300.
How embarrassing. Thanks for catching!

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
