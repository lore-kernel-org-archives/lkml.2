Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab2J1TGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:06:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49120 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2J1TGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:06:18 -0400
MIME-Version: 1.0
In-Reply-To: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
References: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
Date: Sun, 28 Oct 2012 20:06:17 +0100
Message-ID: <CACRpkdYiMu7fRGAhEfy7YfLon0CbC=6c5SwJ2kNP5JnwNaaKPw@mail.gmail.com>
Subject: Re: [PATCH] dma: ste_dma40: use for_each_set_bit
From: Linus Walleij <linus.walleij@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 5:49 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Replace open-coded loop with for_each_set_bit().
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>

Makes perfect sense to me,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
