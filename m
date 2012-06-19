Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2FSKwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:52:24 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46831 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2FSKwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:52:23 -0400
MIME-Version: 1.0
In-Reply-To: <1340102792-7633-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <CAOh2x=k024nEQ3_K03YTFw+inWerB3N+Tjvwh8RiqYA4qSieOg@mail.gmail.com>
	<1340102792-7633-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 19 Jun 2012 11:52:22 +0100
Message-ID: <CAOh2x==s4Mj3b1_KNVhArVfaW7KJuXF30hqw90i1938bEA469g@mail.gmail.com>
Subject: Re: [PATCHv2.1] dw_dmac: introduce dwc_chan_disable
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

On Tue, Jun 19, 2012 at 11:46 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This piece of code is used often. Make it as a separate function.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)

Perfect.

Acked-by: Viresh Kumar <viresh.linux@gmail.com>
