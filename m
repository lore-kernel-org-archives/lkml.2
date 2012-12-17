Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2LQQMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:12:08 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60657 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2LQQMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:12:06 -0500
MIME-Version: 1.0
In-Reply-To: <1355753223-3705-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355753223-3705-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 17 Dec 2012 21:42:05 +0530
Message-ID: <CAKohpok_qFGyN=K4bqUFfz5_jLEZrtvPS-wUSqezPWDObTWfGw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dma: dw_dmac: add dwc_chan_pause and dwc_chan_resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2012 19:37, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> We will use at least the dwc_chan_resume() later.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

For both patches:
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Just fix the logs and repost with my Acks.
