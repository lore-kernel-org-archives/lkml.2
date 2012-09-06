Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2IFHS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:18:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53087 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2IFHSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <1346767113.3160.1.camel@phoenix>
References: <1346767113.3160.1.camel@phoenix>
Date: Thu, 6 Sep 2012 09:18:24 +0200
Message-ID: <CACRpkdYBTALgwkqKSJcpi1pO1-esfXg8CyjJLqGJf-wv69ufpw@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Use irq_data_get_irq_chip_data() at appropriate places
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Magnus Damm <damm@opensource.se>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 3:58 PM, Axel Lin <axel.lin@gmail.com> wrote:

> Then we can remove irq_to_priv() function.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks, applied.

Yours,
Linus Walleij
