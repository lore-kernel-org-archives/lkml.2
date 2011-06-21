Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1FUKO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:14:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35023 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1FUKOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:14:52 -0400
Date: Tue, 21 Jun 2011 11:14:39 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCHv4] x86, mrst: share APB timer code with other platforms
Message-ID: <20110621101439.GH2647@pulham.picochip.com>
References: <1307360587-302-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307360587-302-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 12:43:07PM +0100, Jamie Iles wrote:
> The APB timers are an IP block from Synopsys (DesignWare APB timers)
> and are also found in other systems including ARM SoC's.  This patch
> adds functions for creating clock_event_devices and clocksources from
> APB timers but does not do the resource allocation.  This is handled
> in a higher layer to allow the timers to be created from multiple
> methods such as platform_devices.
> 
> Changes since v3:
> 	- Add dw_apb_clocksource_unregister()
> 	- Move kerneldoc to the implementation file
> Changes since v2:
> 	- Make eoi() for clock_event_device optional for x86 where eoi                                                                                                                                                                                                                                                         
> 	  is handled in firmware.
> Changes since v1:
> 	- Use the correct timer for clocksource on x86
> 	- Select the correct timer rating for x86
> 	- Restore freerunning timer behaviour for oneshot event devices
> 	- Reenable event irq correctly for hotplug
> 
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---

Ping?

Jamie
