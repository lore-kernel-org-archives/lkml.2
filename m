Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2JVIzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:55:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33696 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2JVIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <50813EB0.9040102@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
	<1350477107-26512-3-git-send-email-stigge@antcom.de>
	<20121017190520.GC25996@kroah.com>
	<507FD4EB.1080204@antcom.de>
	<CACRpkda35jKs9YVNDAo96=0QzdMi+jkvJAzM=nX+HCK-d5+e9Q@mail.gmail.com>
	<50813EB0.9040102@antcom.de>
Date: Mon, 22 Oct 2012 10:55:48 +0200
Message-ID: <CACRpkdagQhUjdbda55JaY-J33MTNsEMMFJ=1je8V428ZkEMb9A@mail.gmail.com>
Subject: Re: [PATCH RFC 02/15 v5] gpio: Add sysfs support to block GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 1:51 PM, Roland Stigge <stigge@antcom.de> wrote:

> [Me]
>> The block GPIO stuff is just following that design pattern.
>
> So what do you think about my just proposed idea of always having the
> "value" argument present, but only useable when "exported" is "1"? Now
> only talking about the block gpios, but later maybe also for gpios?

We should atleast be consistent and do it the same way for
blocks as individual gpios.

> But I would only do this if you and Greg consider it reasonable.

I'm still afraid of this whole thing and would seek Grant's consent.

Yours,
Linus Walleij
