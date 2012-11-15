Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768229Ab2KOPiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:38:21 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63122 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767939Ab2KOPiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:38:19 -0500
MIME-Version: 1.0
In-Reply-To: <1352993269.11158.340.camel@smile>
References: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1352989248-28913-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=mpzinz4xr4poNtX0Mom65kfptGM047-hu+XDLTS7m2rw@mail.gmail.com>
	<1352992898.11158.338.camel@smile>
	<CAKohpo=F1SmD0qCn9ybOOQ9VXWFQ-BY=udPgrWYPa23M2PuU_g@mail.gmail.com>
	<1352993269.11158.340.camel@smile>
Date: Thu, 15 Nov 2012 21:08:18 +0530
Message-ID: <CAKohpokPEuHy_rmjamLWZRu32f56W29Wo06EbWr4C2iqNqzvXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: make usage of dw_dma_slave optional
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2012 20:57, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Well, the prep_* should assign the value due to changes of check in the
> dwc_descriptor_complete. Otherwise we will potentially skip some
> important piece of code.

What i meant to say was, set_runtime_config() must have already done this part.

--
viresh
