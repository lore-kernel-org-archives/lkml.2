Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400Ab1IKViN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 17:38:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49507 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1IKViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 17:38:12 -0400
MIME-Version: 1.0
In-Reply-To: <1315383059-3673-34-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
	<1315383059-3673-34-git-send-email-yong.zhang0@gmail.com>
Date: Sun, 11 Sep 2011 23:38:12 +0200
Message-ID: <CACRpkdaxAg++PqW0GxcTR8LNqffsg619gK7SoDqsXR6RyiEKnQ@mail.gmail.com>
Subject: Re: [PATCH 33/62] dmaengine: irq: Remove IRQF_DISABLED
From: Linus Walleij <linus.walleij@linaro.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, mingo@elte.hu, tglx@linutronix.de,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 10:10 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> This flag is a NOOP and can be removed now.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
