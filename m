Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2AQIPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:15:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38376 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab2AQIPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:15:08 -0500
MIME-Version: 1.0
In-Reply-To: <4F12AB3E.4010103@freemail.hu>
References: <4F12AB3E.4010103@freemail.hu>
Date: Tue, 17 Jan 2012 09:15:08 +0100
Message-ID: <CACRpkdY5gAy=-cLrUN0witKBszCQ4gsFCpTxGK0jWoESF7eeVA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio-pch: cleanup NULL pointer checking
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
> This patch will remove the following sparse warning ("make C=1"):
>  * warning: Using plain integer as NULL pointer

Acked-by: Linus Walleij <linus.walleij@linaro.org>

On this and the other NULL-check patch.

Yours,
Linus Walleij
