Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2LNP2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:28:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47144 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab2LNP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:28:38 -0500
MIME-Version: 1.0
In-Reply-To: <1355478222-10610-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355478222-10610-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 14 Dec 2012 20:58:37 +0530
Message-ID: <CAKohpomjiS=0F_PQYtPaAx1oi=Cr4Taaxt9FTuCKGQF9cCPvuA@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: update tx_node_active in dwc_do_single_block
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 December 2012 15:13, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The "else" keyword in the dw_dma_tasklet is removed as well. All together
> simplifies the logic of the code and understanding of what is happening there.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

Sorry for doing this late, was finding some time to go through code :)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
