Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2DLEfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:35:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:46112 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2DLEfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:35:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129923751"
Subject: Re: [tip:timers/urgent] clockevents: tTack broadcast device mode
 change in tick_broadcast_switch_to_oneshot()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alex Shi <lkml.alex@gmail.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, tglx@linutronix.de,
        Alex Shi <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <CAGjg+kFqZ2g4GV8r-NLujMVP7p9W2vUNZszxEFVs6eohSFv_PA@mail.gmail.com>
References: <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
	 <tip-fa4da365bc7772c2cd6d5405bdf151612455f957@git.kernel.org>
	 <CAGjg+kFqZ2g4GV8r-NLujMVP7p9W2vUNZszxEFVs6eohSFv_PA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Wed, 11 Apr 2012 21:35:54 -0700
Message-ID: <1334205354.2583.1.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 09:27 +0800, Alex Shi wrote:
> This patch recovered the loopback netperf testing on NHM machine, but
> on SNB machine, It isn't need a broadcost timer at all.
> 
> Do you think it is better to remove oneshot broadcast on WSM/SNB machine?

on WSM/SNB, we already don't use broadcast timer and always use
apictimer instead.

thanks,
suresh

