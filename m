Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0JSXcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:32:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46031 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0JSXcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:32:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6141"; a="58467620"
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
From: Daniel Walker <dwalker@codeaurora.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: mattw@codeaurora.orgmattw, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        mattw@codeaurora.org
In-Reply-To: <1287387875-14168-1-git-send-email-ohad@wizery.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 16:31:30 -0700
Message-ID: <1287531090.9245.139.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 09:44 +0200, Ohad Ben-Cohen wrote:
> OMAP4 introduces a Spinlock hardware module, which provides hardware
> assistance for synchronization and mutual exclusion between heterogeneous
> processors and those not operating under a single, shared operating system
> (e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP).
> 
> The intention of this hardware module is to allow remote processors,
> that have no alternative mechanism to accomplish synchronization and mutual
> exclusion operations, to share resources (such as memory and/or any other
> hardware resource).
> 
> This patchset adds a new misc driver for this OMAP hwspinlock module.

Does this code interface with some hardware unit (other than the other
processors) to accomplish this locking ?

The reason I ask is because MSM has similar code, and from what I can
tell the MSM version has some structures in memory but that's all. It
just operates on the structures in memory.

It might be worth looking over the two implementation so we aren't both
remaking the wheel.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

