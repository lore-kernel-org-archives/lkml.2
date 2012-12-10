Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2LJPBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:01:19 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:51659 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2LJPBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:01:18 -0500
MIME-Version: 1.0
In-Reply-To: <1355151586-5207-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355151586-5207-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 10 Dec 2012 20:31:18 +0530
Message-ID: <CAKohpokv+eXJNQAfu6SjYA9Um__NikhMAceKmr1KHUehq85A4Q@mail.gmail.com>
Subject: Re: [PATCHv3] dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 20:29, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The same information could be exctracted from the struct dma_chan.
> The patch introduces helper function dwc_get_data_width() as well.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

So sorry for taking this long :(

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
