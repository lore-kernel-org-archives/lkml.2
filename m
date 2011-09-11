Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab1IKVhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 17:37:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39022 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1IKVhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 17:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <1315383059-3673-59-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
	<1315383059-3673-59-git-send-email-yong.zhang0@gmail.com>
Date: Sun, 11 Sep 2011 23:37:04 +0200
Message-ID: <CACRpkdbh-pzPwAr1w=16gYo0vOuMqkfU29Ravfc_M5osWZdx7Q@mail.gmail.com>
Subject: Re: [PATCH 58/62] watchdog: irq: Remove IRQF_DISABLED
From: Linus Walleij <linus.walleij@linaro.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, tglx@linutronix.de, mingo@elte.hu,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 10:10 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:

> This flag is a NOOP and can be removed now.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
