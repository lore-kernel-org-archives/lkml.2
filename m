Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2HANcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:32:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2HANcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:32:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/6] ARM: ux500: Ensure probing of Audio devices when Device Tree is enabled
Date: Wed, 1 Aug 2012 13:32:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <201207312054.13818.arnd@arndb.de> <5018DBEE.9090203@linaro.org>
In-Reply-To: <5018DBEE.9090203@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208011332.02500.arnd@arndb.de>
X-Provags-ID: V02:K0:OF7jWUCPHAU5pyhrgmWc0ALy1yVJgfYcDcC3hJ0tqyF
 vW+y0mtweR8QWkZ5mhrW2JDvVihhKkM5fcidt4w839yeGCH8Lh
 M7QXPRFnlFOfdnV0Vg7K80k3f/XGsR/YJIj6VPpI8Tw0V+GE7t
 alAK68YaCAbYlALYxicj0ToKUHmq6KWfdSf8LI5YUGJORLdDjJ
 6HTRjvVnSt746Lu3WLlVamtKCT739HM75KmCbtgtrW+e2hoCrX
 ZPHOYd1nJhAX/gw/P37RKDZit4W+aY8SNbTtwfvUlttfw+QvZy
 cYnT3Qf7MWjDfH+63bg3lQzW49jFpGqIn/k5D2Uu2EBA7p02Vq
 fozbYI1WFqs+IiTbbOtY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2012, Lee Jones wrote:
> > Looks like you're adding the same call to each of the three cases:
> > mop500, snowball and hrefv60+. How about moving it before or after
> > the if/elseif block?
> 
> The Snowball one is different 'mop500_msp_init' -> 'mop500_of_msp_init'.

Ah, I see. Is there a problem in always using mop500_of_msp_init then?
I would guess that this just means you'd have to put the msp into the
device tree files, which don't yet exist for mop500 and hrefv60.

	Arnd
