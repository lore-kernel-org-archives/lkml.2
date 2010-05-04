Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab0EDOoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:44:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35292 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab0EDOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a5eiHdJJ5AOmiHefitqHAKqk535OaVQANQJWPMOFwflVVPCKRYtLbpY3ObgwKpyzO7
         iPevQFlbL+d6D861Z4gmMxMjz0P9BpBQhSbysX3v/GYmHGU7jHz3KwfPvLUODAc8ddI2
         XkS/7396bedspR9RNz0JrUiu/FJzfPnpPsv64=
MIME-Version: 1.0
In-Reply-To: <y2q3c17e3571005031944z321ffb98w54b5534dcf195ec6@mail.gmail.com>
References: <1272819933.16886.19.camel@lenovo>
	 <y2q3c17e3571005031944z321ffb98w54b5534dcf195ec6@mail.gmail.com>
Date: Tue, 4 May 2010 16:44:19 +0200
Message-ID: <w2m3e4778d51005040744g95e27cdbs451cdec10b5ddb84@mail.gmail.com>
Subject: Re: [PATCH] Staging: adis16255: Fix compile error
From: matthias <mensch0815@googlemail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Matthias Brugger <mensch0815@gmail.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

2010/5/4 Barry Song <21cnbao@gmail.com>:
> The main work of this driver is providing sys node for users to access
> data. Which directory will this driver be placed after moving from
> staging? It's better to rewrite it based on IIO. Otherwise, the
> architecture for this kind of driver will be difficult to be
> consistent.

It's not yet decided to which subsystem the driver will be merged to.
But sysfs entries go to /sys/bus/spi/drivers/ so there shouldn't be an
issue if it later moves to IIO.
(what I want to do when IIO gets out of staging).

Regards,
Matthias Brugger

> -barry
>

-- 
motzblog.wordpress.com
