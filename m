Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1K1LaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:30:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52329 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1K1LaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:30:19 -0500
MIME-Version: 1.0
In-Reply-To: <4ED140A7.5040107@solonet.org.ua>
References: <4ECB561A.5080204@solonet.org.ua>
	<74CDBE0F657A3D45AFBB94109FB122FF174F08C7DD@HQMAIL01.nvidia.com>
	<4ED140A7.5040107@solonet.org.ua>
Date: Mon, 28 Nov 2011 12:30:18 +0100
Message-ID: <CACRpkdboYs9xr-H7s2faWk_mwQmAd2SitnUo+=npWU+Rx23tKA@mail.gmail.com>
Subject: Re: [PATCH v3] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Denis Kuzmenko <linux@solonet.org.ua>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 8:40 PM, Denis Kuzmenko <linux@solonet.org.ua> wrote:

> Does that mean that the patch is ready to be picked up by GPIO subsystem
> maintainer? If so, I should wait for Grant Likely to return from his
> Engineering Sabbatical and then repost it again (as he told that he will
> delete his inbox on return)?

Yes collect ACK:s and wait for him to return, then re-send it or
send it directly to him.

Yours,
Linus Walleij
