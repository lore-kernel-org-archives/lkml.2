Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0H0Uii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:38:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530Ab0H0Uig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:38:36 -0400
Date: Fri, 27 Aug 2010 13:38:25 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linux-kernel@vger.kernel.org, Kyle Moffett <kyle@moffetthome.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] sky2: Add unidirectional fiber link support
Message-ID: <20100827133825.494b8098@nehalam>
In-Reply-To: <1282938138-17844-3-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1282938138-17844-1-git-send-email-Kyle.D.Moffett@boeing.com>
	<1282938138-17844-3-git-send-email-Kyle.D.Moffett@boeing.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 15:42:18 -0400
Kyle Moffett <Kyle.D.Moffett@boeing.com> wrote:

> +	/* 
> +	 * Once interrupts are reenabled, reset the PHY again to make sure
> +	 * that we didn't miss a link-up interrupt.  This is especially
> +	 * likely to occur if we're in fiber-txonly mode, as a link-up
> +	 * interrupt is generated almost immediately after we finish
> +	 * programming the PHY.
> +	 */
> +	sky2_phy_reinit(sky2);

Won't this cause a renegotiation causing up to 2 second delay?

-- 
