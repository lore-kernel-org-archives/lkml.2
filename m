Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab1HCKUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:20:12 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60460 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab1HCKUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
References: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
Date: Wed, 3 Aug 2011 12:20:08 +0200
Message-ID: <CACRpkdaQyo+M4irQ9CJC5BSruo+f95M_EHNG3+aTk=FO4LmRAw@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: ux500: set dma config for both src and dst
From: Linus Walleij <linus.walleij@linaro.org>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        users@igloocommunity.org, Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 5:33 PM, Per Forlin <per.forlin@stericsson.com> wrote:

> From: Per Forlin <per.forlin@linaro.org>
>
> The dma driver requires both src and dst to be set.
> This fix is needed in order to run gadget mass storage.
> Patch is verified on snowball.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
