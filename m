Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423114Ab2JaPFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:05:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61064 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423096Ab2JaPFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <1351457210-25222-4-git-send-email-stigge@antcom.de>
References: <1351457210-25222-1-git-send-email-stigge@antcom.de> <1351457210-25222-4-git-send-email-stigge@antcom.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 31 Oct 2012 16:04:55 +0100
X-Google-Sender-Auth: 41FUuTfI01aMvzQpl3HCvYsVt9U
Message-ID: <CACxGe6uNhQgG+p6iO47oWSWiDvuYQtj1x62nrTzHGPr02dj_5w@mail.gmail.com>
Subject: Re: [PATCH RESEND 3/5 v6] gpiolib: Fix default attributes for class
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 9:46 PM, Roland Stigge <stigge@antcom.de> wrote:
> There is a race condition between creating a gpio or gpiochip device and adding
> default attributes. This patch fixes this by defining the default attributes as
> dev_attrs of the class. For this, it was necessary to create a separate
> gpiochip_class besides gpio_class.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

This looks right, but I need to test it....

g.
