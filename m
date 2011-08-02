Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1HBKCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:02:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61381 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1HBKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:02:40 -0400
MIME-Version: 1.0
In-Reply-To: <1307616640-2013-1-git-send-email-mattias.wallin@stericsson.com>
References: <1307616640-2013-1-git-send-email-mattias.wallin@stericsson.com>
Date: Tue, 2 Aug 2011 12:02:39 +0200
Message-ID: <CACRpkdYJK7yJrocEJYudeOW0JbcWMTiqrhz1-mNZO0jc0y3S6g@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: ab5500 chip register access
From: Linus Walleij <linus.walleij@linaro.org>
To: Mattias Wallin <mattias.wallin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 12:50 PM, Mattias Wallin
<mattias.wallin@stericsson.com> wrote:

> The analog baseband chip ab5500 is a multi functional chip
> containing regulators, charging, gpio, USB and accessory detect.
> It also contain various multimedia functionalities like digital
> encoder and audio codec.
> The core driver added with this patch provides register access via
> i2c via PRCMU. Event handling implemented as irq_chip will come in
> future patches since it depends on PRCMU functionality not yet
> implemented.
>
> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sam, what happened to these two patches? Something that needs
to  be fixed about them?

Thanks,
Linus Walleij
