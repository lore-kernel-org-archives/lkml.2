Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2KPOGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:06:23 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61806 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2KPOGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:06:21 -0500
MIME-Version: 1.0
In-Reply-To: <1353074360-1903-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1353074360-1903-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 16 Nov 2012 19:36:21 +0530
Message-ID: <CAKohpon4G2h6DA=WjmBTc+E9Lo1piqqxi8Qf+DLx3P9qVC4=Qw@mail.gmail.com>
Subject: Re: [PATCH 3/6] dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
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

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
