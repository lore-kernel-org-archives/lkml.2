Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1KQJKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:10:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37739 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KQJKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:10:41 -0500
MIME-Version: 1.0
In-Reply-To: <20111116091027.GB2596@pengutronix.de>
References: <1321397074-6526-1-git-send-email-w.sang@pengutronix.de>
	<4EC2F035.3060705@solonet.org.ua>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805F1A@HQMAIL01.nvidia.com>
	<4EC371FE.5010402@solonet.org.ua>
	<20111116091027.GB2596@pengutronix.de>
Date: Thu, 17 Nov 2011 10:10:40 +0100
Message-ID: <CACRpkdYEbn3JwvGNfi_Xm86yf=8x4BFqkNkoppTT=452NC=UMw@mail.gmail.com>
Subject: Re: [PATCH] gpio: add flags to export GPIOs when requesting
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Denis Kuzmenko <linux@solonet.org.ua>, Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:10 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:

> BTW I didn't CC Grant, because he is on sabbatical right now, so Stephen
> you are taking care of GPIO?

I'm taking care of prepping GPIO patches for the -rc series for some
two weeks. I think this patch is for-next so I won't be merging it
anyplace. Grant wanted new and reviewed stuff as pull
requests when he gets back.

Linus Walleij
