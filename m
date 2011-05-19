Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453Ab1ESTe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:34:58 -0400
Received: from relais.videotron.ca ([24.201.245.36]:29052 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808Ab1ESTe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:34:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 19 May 2011 15:34:44 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Move Qualcomm gpio drivers into drivers dir
In-reply-to: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
Message-id: <alpine.LFD.2.00.1105191533250.14430@xanadu.home>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011, David Brown wrote:

> This patch series moves the Qualcomm MSM gpio device drivers into the
> drivers/gpio directory.
> 
> The MSM's have two flavors of gpio driver.  The one for the newer
> v7-based chips is a bit cleaner, and can just be moved.  The one for
> the older v6-based chips took some cleanup to get rid of numerous
> ifdefs based on the particular machine.  Both drivers can now be
> selected and will be used on appropriate targets.
> 
> There is still a minor entanglement with the MSM-specific gpiomux
> code.  This will be cleaned up as MSM moves to use pinmux.

Looks good.

Acked-by: Nicolas Pitre <nicolas.pitre@l;inaro.org>


Nicolas
