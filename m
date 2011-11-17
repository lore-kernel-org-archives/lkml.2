Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab1KQMmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:42:37 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48040 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757195Ab1KQMme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:42:34 -0500
Date: Thu, 17 Nov 2011 12:42:26 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: keguang.zhang@gmail.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        zhzhl555@gmail.com, peppe.cavallaro@st.com, wuzhangjin@gmail.com,
        r0bertz@gentoo.org
Subject: Re: [PATCH V3 4/5] MIPS: Add RTC support for Loongson1B
Message-ID: <20111117124226.GB16467@linux-mips.org>
References: <1321522748-21391-1-git-send-email-keguang.zhang@gmail.com>
 <1321522748-21391-4-git-send-email-keguang.zhang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321522748-21391-4-git-send-email-keguang.zhang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 05:39:07PM +0800, keguang.zhang@gmail.com wrote:

> From: Kelvin Cheung <keguang.zhang@gmail.com>
> 
> This patch adds RTC support(TOY counter0) for Loongson1B.
> Thanks Zhao Zhang for implementing this.
> 
> Signed-off-by: zhao zhang <zhzhl555@gmail.com>
> Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
> ---
>  arch/mips/include/asm/mach-loongson1/platform.h |    1 +
>  arch/mips/loongson1/common/platform.c           |    5 +
>  arch/mips/loongson1/ls1b/board.c                |    1 +
>  drivers/rtc/Kconfig                             |   10 +
>  drivers/rtc/Makefile                            |    1 +
>  drivers/rtc/rtc-ls1x.c                          |  210 +++++++++++++++++++++++
>  6 files changed, 228 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-ls1x.c

Please send to the RTC list & maintainers, see MAINTAINERS for the
addresses.  I can accept the RTC patch only with the RTC maintainer's
Acked-by.

Also you may want to split this patch in two patches.  Send the
drivers/rtc/ part to the RTC maintainer & list and merge the
arch/mips bits into patch 2/5.

Thanks,

  Ralf
