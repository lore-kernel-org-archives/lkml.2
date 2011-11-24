Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1KXVcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:32:12 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:42271 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab1KXVcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:32:09 -0500
Date: Thu, 24 Nov 2011 14:32:08 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Kyle Manna <kyle.manna@fuel7.com>
cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@ti.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: Add support for AM35xx UART4/ttyO3
In-Reply-To: <1318963661-27755-1-git-send-email-kyle.manna@fuel7.com>
Message-ID: <alpine.DEB.2.00.1111241430590.6289@utopia.booyaka.com>
References: <1318963661-27755-1-git-send-email-kyle.manna@fuel7.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Kyle Manna wrote:

> Add hwmod support to enable access to UART4 of the AM35xx series of
> chips.  The UART4 device referenced from the TRM will show up as ttyO3.
> 
> This was tested on an AM3505.
> 
> Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>

Thanks, provisionally queued for 3.3.  I've got some hwmod data cleanup 
patches coming up that will require me to modify this patch slightly.  Do 
you think you could give the modified patch a quick test when I repost it?

regards,

- Paul
