Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2KFIwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:52:12 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62222 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2KFIwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:52:10 -0500
MIME-Version: 1.0
In-Reply-To: <1352123068.14769.6.camel@phoenix>
References: <1352123068.14769.6.camel@phoenix>
Date: Tue, 6 Nov 2012 09:52:08 +0100
Message-ID: <CACRpkdbM20TVDC0HGyDpafhWtLmyE-VLqzJjX9Z2btcnVhriRQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sirf: Staticize non-exported symbol
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Barry Song <baohua.song@csr.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:44 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Staticize sirfsoc_gpio_irq_map() function.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Barry's ACK, thanks!
Linus Walleij
