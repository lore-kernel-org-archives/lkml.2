Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2DJIM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:12:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34406 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2DJIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:12:56 -0400
MIME-Version: 1.0
In-Reply-To: <1328771497-3032-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1328771497-3032-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Date: Tue, 10 Apr 2012 10:12:55 +0200
Message-ID: <CACRpkdaXRJVtqgnrkuJ8YUPDp3QSPQR9LmAX=ePdYxzZagKa=w@mail.gmail.com>
Subject: Re: [PATCHv3] dma40: Improve the logic of stopping logical chan
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, rabin.vincent@stericsson.com,
        linus.walleij@stericsson.com, shreshthakumar.sahu@stericsson.com,
        mathieu poirier <mathieu.poirier@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 8:11 AM, Narayanan G
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
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Vinod what happened to this patch?

Can you please push it for the -rc:s since it's solving a real problem
for us...

Yours,
Linus Walleij
