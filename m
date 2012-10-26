Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2JZHft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:35:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49825 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab2JZHfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:35:47 -0400
MIME-Version: 1.0
In-Reply-To: <20121026065942.GB9284@elgon.mountain>
References: <20121026065942.GB9284@elgon.mountain>
Date: Fri, 26 Oct 2012 09:35:46 +0200
Message-ID: <CACRpkdZPDZ_b=md7CXAc+tEkbdX1inw7eyQ4pZ2UdrW=S78vDQ@mail.gmail.com>
Subject: Re: [patch] gpiolib: unlock on error in gpio_export()
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Ryan Mallon <rmallon@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 8:59 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We need to unlock here before returning.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Only needed in linux-next.

Thanks Dan, applied to my devel branch.

Yours,
Linus Walleij
