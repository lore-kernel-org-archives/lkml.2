Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2FSKkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:40:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65075 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2FSKkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 19 Jun 2012 11:40:51 +0100
Message-ID: <CAOh2x==6J3g75+2grTv6HcA3JVboKGAhfA5Fo=kiOipJ_uPQ=w@mail.gmail.com>
Subject: Re: [PATCHv2 00/10] dw_dmac: set of cleanups and small fixes
From: viresh kumar <viresh.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 11:34 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This patchset provides set of the cleanups and small fixes against the
> DesignWare DMA controller driver. It's a first portion of the patches to make
> the driver usable on other platforms.
>
> since v1:
>  - add dwc_chan_reset
>  - disable block interrupts only in probe (discussed with Viresh Kumar)
>  - fix comment line in probe in patch 6
>
> Andy Shevchenko (10):
>  dw_dmac: fix constant in the comment
>  dw_dmac: use proper casting to print dma_addr_t values
>  dw_dmac: introduce dwc_dump_chan_regs to dump registers
>  dw_dmac: print correct number of scanned descriptors
>  dw_dmac: use __func__ constant in the debug prints
>  dw_dmac: disable dma in optimal way in probe
>  dw_dmac: disable BLOCK interrupts
>  dw_dmac: introduce dwc_fast_fls()
>  dw_dmac: move from __init to __devinit
>  dw_dmac: introduce dwc_chan_reset

Leaving minor comment on Patch 10/10, It Looks good.

Acked-by: Viresh Kumar <viresh.linux@gmail.com>
