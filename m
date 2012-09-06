Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab2IFVh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:37:27 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:55895 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115Ab2IFVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:37:24 -0400
Date: Thu, 6 Sep 2012 21:37:23 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
Message-ID: <alpine.DEB.2.00.1209062137000.11516@utopia.booyaka.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi> <1346935540-1792-1-git-send-email-balbi@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, 6 Sep 2012, Felipe Balbi wrote:

> Hi guys,
> 
> here's v4 of the omap uart patchset. No changes other than a rebase on top of
> Greg's tty-next branch and Tony's Acked-by being added to a couple patches
> 
> Note: I'm resending the series with Vikram's Software Flow Control fix anyway
> as it can just be ignored if it's decided it needs to go into this merge
> window.

Was curious to know if these have been PM-tested, and if so, under what 
configurations?


- Paul
