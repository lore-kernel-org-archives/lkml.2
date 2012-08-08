Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2HHP1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:27:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40639 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2HHP1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:27:35 -0400
MIME-Version: 1.0
In-Reply-To: <1344430493-5304-2-git-send-email-arnd@arndb.de>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
	<1344430493-5304-2-git-send-email-arnd@arndb.de>
Date: Wed, 8 Aug 2012 23:27:34 +0800
Message-ID: <CAN1soZy8nWpneqgbA7tdN-868WW8QC7SVHoGDRqyKz_=mTJEAQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] ARM: pxa: remove irq_to_gpio from ezx-pcap driver
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, "v3.2+" <stable@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Ribeiro <drwyrm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 8:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The irq_to_gpio function was removed from the pxa platform
> in linux-3.2, and this driver has been broken since.
>
> There is actually no in-tree user of this driver that adds
> this platform device, but the driver can and does get enabled
> on some platforms.
>
> Without this patch, building ezx_defconfig results in:
>
> drivers/mfd/ezx-pcap.c: In function 'pcap_isr_work':
> drivers/mfd/ezx-pcap.c:205:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: stable@vger.kernel.org (v3.2+)
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Daniel Ribeiro <drwyrm@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/mfd/ezx-pcap.c       |    2 +-
>  include/linux/mfd/ezx-pcap.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
