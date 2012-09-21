Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2IUApG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:45:06 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:60937 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab2IUApD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:45:03 -0400
Date: Fri, 21 Sep 2012 00:45:02 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: OMAP: hwmod: revise deassert sequence
In-Reply-To: <1345614150-25723-3-git-send-email-omar.luna@linaro.org>
Message-ID: <alpine.DEB.2.00.1209210044300.6888@utopia.booyaka.com>
References: <1345614150-25723-1-git-send-email-omar.luna@linaro.org> <1345614150-25723-3-git-send-email-omar.luna@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, 22 Aug 2012, Omar Ramirez Luna wrote:

> For a reset sequence to complete cleanly, a module needs its
> associated clocks to be enabled, otherwise the timeout check
> in prcm code can print a false failure (failed to hardreset)
> that occurs because the clocks aren't powered ON and the status
> bit checked can't transition without them.
> 
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>

Queued for 3.7, with the same caveats mentioned regarding patch 1.


- Paul
