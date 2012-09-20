Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2ITJcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:32:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42006 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2ITJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <1348133405.13371.30.camel@smile>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==Te7MBNrqX-wjaPzso_xTC44rUejMDhs7SW7HJag7j8g@mail.gmail.com>
	<1347951305.13371.10.camel@smile>
	<CAOh2x=k3hjXtuAd23LYLWvG59HPgFS8W2J+5-2Bre+wFufgcng@mail.gmail.com>
	<1348133405.13371.30.camel@smile>
Date: Thu, 20 Sep 2012 15:02:29 +0530
X-Google-Sender-Auth: W73c72wI3E2LmfR64nHFYCFAnh8
Message-ID: <CAOh2x=nqi=8kURCoZYXetVCZsTKgHa=77_vuqkq-ZrMOZaiY4A@mail.gmail.com>
Subject: Re: [PATCH 2/7] dw_dmac: fill optional encoded parameters in register structure
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 3:00 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>> Ok. If i am not wrong, such calls are only required once for below line:
> Actually twice...
>> dw_params = dma_raw_readl(regs, DW_PARAMS
> ...here and for channel parameters.

Till the time we hit channel code, we can allocate memory for dw and so
can use dma_readl/writel. Isn't it?

viresh
