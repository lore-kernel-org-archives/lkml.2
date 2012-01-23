Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2AWTR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:17:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43212 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2AWTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:17:56 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812C6D0D1@EXMAIL03.scwf.nsc.com>
References: <AczXFeD/IVI/swmRQEeq7C0EMZQ8sA==>
	<B567DBAB974C0544994013492B949F8E3812C6D0D1@EXMAIL03.scwf.nsc.com>
Date: Mon, 23 Jan 2012 20:17:55 +0100
Message-ID: <CACRpkdbDSVhGYpfO1caYaBdpqk15pXywU1yJ1pKcYg=nUkoT3g@mail.gmail.com>
Subject: Re: [PATCH 5/7] leds-lm3530: replace 'i2c_client' with 'led_classdev'
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 2:50 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> To get members of lm3530_data, use 'struct led_classdev' rather than
> 'struct i2c_client'.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Looks clever, and if it also works it's good :-)
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
