Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2KPOFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:05:39 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34823 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2KPOFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:05:36 -0500
MIME-Version: 1.0
In-Reply-To: <1353074360-1903-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353074360-1903-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 16 Nov 2012 19:35:34 +0530
Message-ID: <CAKohpokzvb7=u6g2fcc=1RyyUJzWrvsnve1705Mrfbqz2U_1JQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] dma: at_hdmac: check direction properly for cyclic transfers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2012 19:29, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> dma_transfer_direction is a normal enum. It means we can't usually use the
> values as bit fields. Let's adjust this check and move it above the usage of
> the direction parameter.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
