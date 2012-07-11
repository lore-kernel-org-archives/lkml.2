Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab2GKVy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:54:27 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:43032 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2GKVyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:54:24 -0400
MIME-Version: 1.0
In-Reply-To: <1341997995-14020-3-git-send-email-tarun.kanti@ti.com>
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
	<1341997995-14020-3-git-send-email-tarun.kanti@ti.com>
Date: Wed, 11 Jul 2012 23:54:23 +0200
Message-ID: <CACRpkdYxE7rj8HHAy3+HbQHW4+WbqK2suggfBqKX=TbhHzraDg@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio/omap: add *remove* callback in platform_driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 11:13 AM, Tarun Kanti DebBarma
<tarun.kanti@ti.com> wrote:

> Add *remove* callback so that necessary cleanup operations are
> performed when device is unregistered. The device is deleted
> from the list and associated clock handle is released by
> calling clk_put() and irq descriptor is released using the
> irq_free_desc() api.
>
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

Looks good, applied.

Yours,
Linus Walleij
