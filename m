Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0IMSOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:14:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63304 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0IMSOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dsRko0QFJle9ggqNVifSI5XFuzd0MyqVzIzTYDDsdBqrb+FJA4GrmKipPNyfnvWj67
         tpfrKrOvyUPNO4iCbR1fLLbszt09bazMDhnrJ/GEZkjDmd3mVQpQjFYv8F/KJPCiG5+l
         09eGNgsfNIrckzpWoiR+jp+gWW9KcngyPhK7U=
MIME-Version: 1.0
In-Reply-To: <1282324404-3480-1-git-send-email-henne@nachtwindheim.de>
References: <1282324404-3480-1-git-send-email-henne@nachtwindheim.de>
Date: Mon, 13 Sep 2010 20:14:52 +0200
X-Google-Sender-Auth: n1W7QowSiX2yqvxVtdYdT7WXxPE
Message-ID: <AANLkTimHxWHfqh2hP8SPvTD7rcXwiC4Ar-adENM3phwu@mail.gmail.com>
Subject: Re: [PATCH 1/4] fbdev: fix section mismatches in q40fb.c
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-fbdev@vger.kernel.org, arnaud.patard@rtp-net.org,
        u.kleine-koenig@pengutronix.de, jayakumar.lkml@gmail.com,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 19:13, Henrik Kretzschmar
<henne@nachtwindheim.de> wrote:
> This patch moves the q40_fix and q40_var structures from .init.data
> to .devinit.data.
> This is where now the probe function resides, which only uses them.
>
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Applied

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
