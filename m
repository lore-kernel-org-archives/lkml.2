Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab1K3PYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:24:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40765 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1K3PYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:24:30 -0500
MIME-Version: 1.0
In-Reply-To: <1322661042-18645-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1322661042-18645-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Date: Wed, 30 Nov 2011 16:24:29 +0100
Message-ID: <CACRpkdZEnibk4feDEW3-noXouuyK84WJAFeFEKq=9TBfmyxNKQ@mail.gmail.com>
Subject: Re: [PATCH] dmaengine/ste_dma40: allow fixed physical channel
From: Linus Walleij <linus.walleij@linaro.org>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linus.walleij@stericsson.com,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 2:50 PM, Narayanan G
<narayanan.gopalakrishnan@stericsson.com> wrote:

> Allow logical channels to specify the physical channel they want to use.
> This is needed to avoid two peripherals operating on the same physical
> channel during some special use-cases. (like mmc and usb during a
> usb mass storage case).
>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

(I reviewed and provided feedback some time ago, I'm likely blind for
any remaining issues.)

Yours,
Linus Walleij
