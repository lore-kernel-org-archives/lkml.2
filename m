Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1ILKAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 06:00:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46663 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1ILKAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:00:36 -0400
Message-ID: <4E6DD816.7040809@ru.mvista.com>
Date: Mon, 12 Sep 2011 13:59:50 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/28] ide-{cd,floppy,tape}: Do not include <linux/irq.>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org> <1315742394-16036-3-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1315742394-16036-3-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-09-2011 15:59, Geert Uytterhoeven wrote:

> The top of <linux/irq.h> has this comment:

>   * Please do not include this file in generic code.  There is currently
>   * no requirement for any architecture to implement anything held
>   * within this file.
>   *
>   * Thanks. --rmk

> Remove inclusion of <linux/irq.>, to prevent the following compile error

    <linux/irq.h>? You've also typoed in the subject.

> from happening soon:

> | include/linux/irq.h:132: error: redefinition of ‘struct irq_data’
> | include/linux/irq.h:286: error: redefinition of ‘struct irq_chip’

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-ide@vger.kernel.org

WBR, Sergei
