Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1FZLK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 07:10:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45820 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab1FZLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 07:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kY8AfQf9NAcTGie1rJ98sojr3DjbrchaA78RPhKNc4fv7oiQArgSP4Obj+DjgKuZ8S
         f2hVsHpY4AT6bdjVX1Dd8veafGBMOszPwYnThTTkCRjddEB+eMIb+7pKoZL35zcxmvws
         EKyJhmcAU6MZna4yr4IoZZwLa04ns5gT5Kw9I=
MIME-Version: 1.0
In-Reply-To: <1309039804-659-4-git-send-email-bryan.wu@canonical.com>
References: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
	<1309039804-659-4-git-send-email-bryan.wu@canonical.com>
Date: Sun, 26 Jun 2011 13:10:48 +0200
X-Google-Sender-Auth: Uag20hbFYQ_VP_yJiIFDII00dB0
Message-ID: <BANLkTinx0uFE-ODhTcpsJdE5KSq_C8aB6g@mail.gmail.com>
Subject: Re: [PATCH 3/4] mach-realview: retire custom LED code
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/26 Bryan Wu <bryan.wu@canonical.com>:

> This replaces the custom LED trigger code in mach-realview with
> some overarching platform code for the plat-versatile family that
> will lock down LEDs 2 thru 5 for CPU activity indication. The
> day we have 8 core ARM systems the plat-versatile code will have
> to become more elaborate.
>
> Tested on RealView PB11MPCore by invoking four different CPU
> hogs (yes > /dev/null&) and see the LEDs go on one at a time.
> They all go off as the hogs are killed. Tested on the PB1176
> as well - just one activity led (led 2) goes on and off with
> CPU activity.
>
> (bryan.wu@canonical.com: use ledtrig-cpu instead of ledtrig-arm-cpu)
>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

This is good, especially the KConfig fixups, but also include Pawel Moll's
Acked-by on these patches.

Linus Walleij
