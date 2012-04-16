Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab2DPLSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:18:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47861 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2DPLSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:18:16 -0400
MIME-Version: 1.0
In-Reply-To: <1334564854-6102-1-git-send-email-linus.walleij@stericsson.com>
References: <1334564854-6102-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 16 Apr 2012 13:18:15 +0200
Message-ID: <CACRpkdZuTJHQSFoLjjVjewtz6YR3gLmeGrP-RY+GfN1y1RzR_g@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd/db5500-prcmu: delete DB5500 PRCMU support
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>,
        Ulf Hansson <ulf.hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:27 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> This platform has been obsoleted and was only available inside of
> ST-Ericsson, no users of this code are left in the world. This
> deletes the core U5500 support entirely in the same manner as the
> obsoleted U8500 silicon was previously deleted.
>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Rabin Vincent <rabin.vincent@stericsson.com>
> Cc: Jonas Aberg <jonas.aberg@stericsson.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Ulf Hansson <ulf.hansson@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

BTW Sam, these have cross-dependencies on stuff happening in arch/arm/mach-ux500
so if I can get ACKs for this it's better if I merge it through the
AMR SoC tree.

HOWEVER: if you apply Axel Lin's patch reording all the KConfig entries, that
will *not* work, we might have to merge this during the merge window in that
case, so I want to know how to proceed here ... if the Kconfig patch is applied
to the -rc:s or postponed, I can merge these two patches.

Yours,
Linus Walleij
