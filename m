Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2HGMex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:34:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35915 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2HGMet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:34:49 -0400
MIME-Version: 1.0
In-Reply-To: <1344099049-15212-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1344099049-15212-4-git-send-email-Julia.Lawall@lip6.fr>
Date: Tue, 7 Aug 2012 14:34:48 +0200
Message-ID: <CACRpkdYLL+butu_kruQY48hrzZ7Jtig9wkN8bC6kxDvLpOyUvQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] drivers/pinctrl/pinctrl-nomadik.c: drop devm_kfree of
 devm_kzalloc'd data
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 4, 2012 at 6:50 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> devm_kfree should not have to be explicitly used.
>
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)

Applied.

Thanks,
Linus Walleij
