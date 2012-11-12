Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2KLODO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:03:14 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62265 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2KLODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <1352719406-26405-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1352719406-26405-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 12 Nov 2012 19:33:12 +0530
X-Google-Sender-Auth: v_W86FWyi_8k4HtSCn7AvDhVBFY
Message-ID: <CAOh2x=n5AM2ee_Skj79Vk4s3=G79VRBVUBverZ7aveX5RikBHQ@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: absence of pdata isn't critical when autocfg is set
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 4:53 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> +       if (!pdata && autocfg)
> +               pdata = &dw_dma_pdata;
> +
> +       if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
> +               return -EINVAL;
> +

Another thing: replace the  second if with else if :)
