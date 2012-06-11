Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2FKUy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:54:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51209 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2FKUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:54:58 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-4-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-4-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 22:54:57 +0200
Message-ID: <CACRpkdZrW=3siTjhGDPBZZcOTkekgX3xUUmiQnmxZ664q2eKZw@mail.gmail.com>
Subject: Re: [PATCH 03/14] mfd: ab8500-gpadc: Enable IRQF_ONESHOT when
 requesting a threaded IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Arun MURTHY <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:24 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
