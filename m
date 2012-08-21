Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2HUJoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:44:44 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:40934 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884Ab2HUJok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <1345540555-24359-6-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com> <1345540555-24359-6-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Tue, 21 Aug 2012 15:14:19 +0530
Message-ID: <CAMQu2gw93ES=u9J1FfWK_CKkgUq8V487+tmKtQ34p8O7VJ6aHA@mail.gmail.com>
Subject: Re: [RFC/PATCH 05/13] serial: omap: drop DMA support
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 2:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> The current support is known to be broken and
> a later patch will come re-adding it using
> dma engine API.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
Thanks Felipe !!
One less driver now towards OMAP DMA
engine conversion.

FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
