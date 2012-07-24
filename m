Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2GXIIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:08:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53930 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab2GXIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <1343116855-6804-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1343116855-6804-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 24 Jul 2012 09:08:41 +0100
X-Google-Sender-Auth: ZDCTu3R2StIvbvmyNie-Rrn-7i0
Message-ID: <CAOh2x=nW=OUHGpaaYYxTN+rgnmF7Nb2R-wy=aSDfRhLPQeYSaQ@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: use devm_* functions to simplify code
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 9:00 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Use devm_kzalloc, devm_clk_get, devm_request_irq, and devm_request_and_ioremap
> to reduce the code and to simplify the error path.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> ---
>  drivers/dma/dw_dmac.c      |   53 +++++++++-----------------------------------
>  drivers/dma/dw_dmac_regs.h |    2 --
>  2 files changed, 10 insertions(+), 45 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
