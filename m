Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2AQIOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:14:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50791 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2AQIOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:14:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F12AB38.5040009@freemail.hu>
References: <4F12AB38.5040009@freemail.hu>
Date: Tue, 17 Jan 2012 09:14:21 +0100
Message-ID: <CACRpkdZ0osKrjTXsV96J5ckj=wC=OieHL7UTfjtm8ibHRuL6=A@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio-pch: cleanup __iomem annotation usage
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/15 Németh Márton <nm127@freemail.hu>:

> From: Márton Németh <nm127@freemail.hu>
>
> The __iomem annotation is to be used together with pointers used
> as iowrite32() parameter. For more details see [1] and [2].
(...)
> -       u32 *im_reg;
> +       u32 __iomem *im_reg;

Does it work to just say void __iomem *im_reg?

We usually don't type addresses.

Yours,
Linus Walleij
