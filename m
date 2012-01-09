Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab2AIPWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:22:02 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39986 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932066Ab2AIPWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:22:00 -0500
MIME-Version: 1.0
In-Reply-To: <1325830384-13211-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1325830384-13211-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Date: Mon, 9 Jan 2012 16:21:59 +0100
Message-ID: <CACRpkdYaUb3eifZbYNRPHiqzXpn=K15GNHWvDxcxRw9mPCG6hQ@mail.gmail.com>
Subject: Re: [PATCHv2] dma40: Improve the logic of stopping logical chan
From: Linus Walleij <linus.walleij@linaro.org>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        rabin.vincent@stericsson.com, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 7:13 AM, Narayanan G
<narayanan.gopalakrishnan@stericsson.com> wrote:

> From the V2 version of the controller a logical channel
> can be directly stopped by issuing a SUSPEND_REQ on the EE
> bits. There is no need to suspend the physical channel and
> restart it.
>
> Also, the support for pre-V2 hw is discontinued.
>
> EE bits for writing:
>
> 00: disable only if AS=11 or AS=00
> 01: enable
> 10: suspend_req only if AS=01 & EE=01 or EE=11
> 11: round / no change for writing
>
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

However this looks a bit strange and gives a warning when applying the
patch:

> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index cc5ecbc..8009e8b1 100755

100755?

Did you accidentally execute something like chmod -R 755 ...?

Well, it works fine anyway.

Yours,
Linus Walleij
