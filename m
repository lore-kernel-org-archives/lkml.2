Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2H3QuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:50:22 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:49039 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693Ab2H3QuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <1346337826-27232-2-git-send-email-m-karicheri2@ti.com>
References: <1346337826-27232-1-git-send-email-m-karicheri2@ti.com> <1346337826-27232-2-git-send-email-m-karicheri2@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 30 Aug 2012 09:49:54 -0700
Message-ID: <CAMQu2gyuVHEz-gUK3Tzqy4DPRwP+NWWjJTCYS=-RzFuszHw9Wg@mail.gmail.com>
Subject: Re: [PATCH - 2/2] arm: disable caches based on config option
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, tony@atomide.com,
        wim@iguana.be, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 7:43 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> CONFIG_CPU_ICACHE_DISABLE and CONFIG_CPU_DCACHE_DISABLE are available
> to allow disabling of D-Cache and I-Cache. However the compressed version
> of head.S currently doesn't check these variables. This patch will fix
> this issue and is written similar to the uncompressed version of head.S
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
