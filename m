Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0HWV6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:58:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48357 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0HWV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=DIHHURIHKstlCet1qQxK4iR/2LfEC+1syuZPGNrHK+7z0g19W6T7KnE+wxHkPp1xJE
         5bBdUJU4cGNxAKKciayiS6PFOGLDuaEgxLvDEVLgSzjn1XXAarEV20lxpkbdXKYgKtLk
         hyqMlhyWZQZoyVo4HhJezLbuU6hHWX9w7w9+w=
MIME-Version: 1.0
In-Reply-To: <1282575908-16555-1-git-send-email-w.sang@pengutronix.de>
References: <1282575908-16555-1-git-send-email-w.sang@pengutronix.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 23 Aug 2010 17:58:17 -0400
X-Google-Sender-Auth: Sk1KjU1wVAsr2SqBsESQfZTVLz0
Message-ID: <AANLkTikupuVAhC9Dj-9QgDzMVBd6vfh5OjFXGsXnwnFK@mail.gmail.com>
Subject: Re: [PATCH] i2c: remove obsolete cleanup for clientdata
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Mack <daniel@caiaq.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Hemanth V <hemanthv@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Jingchang Lu <b22599@freescale.com>,
        Mingkai Hu <Mingkai.hu@freescale.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:05, Wolfram Sang <wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit. This is obsolete meanwhile, so fix it and hope the word will spread.

on a related note, do we need to clear it when erroring at probe time
?  doesnt seem like that is necessary either ...
-mike
