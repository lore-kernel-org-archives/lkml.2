Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab1FWXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:09:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45432 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab1FWXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:09:54 -0400
Subject: Re: [PATCHv4] x86, mrst: share APB timer code with other platforms
From: john stultz <johnstul@us.ibm.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
In-Reply-To: <20110621101439.GH2647@pulham.picochip.com>
References: <1307360587-302-1-git-send-email-jamie@jamieiles.com>
	 <20110621101439.GH2647@pulham.picochip.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 16:09:48 -0700
Message-ID: <1308870588.2872.124.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 11:14 +0100, Jamie Iles wrote:
> On Mon, Jun 06, 2011 at 12:43:07PM +0100, Jamie Iles wrote:
> > The APB timers are an IP block from Synopsys (DesignWare APB timers)
> > and are also found in other systems including ARM SoC's.  This patch
> > adds functions for creating clock_event_devices and clocksources from
> > APB timers but does not do the resource allocation.  This is handled
> > in a higher layer to allow the timers to be created from multiple
> > methods such as platform_devices.
> > 
> > Changes since v3:
> > 	- Add dw_apb_clocksource_unregister()
> > 	- Move kerneldoc to the implementation file
> > Changes since v2:
> > 	- Make eoi() for clock_event_device optional for x86 where eoi                                                                                                                                                                                                                                                         
> > 	  is handled in firmware.
> > Changes since v1:
> > 	- Use the correct timer for clocksource on x86
> > 	- Select the correct timer rating for x86
> > 	- Restore freerunning timer behaviour for oneshot event devices
> > 	- Reenable event irq correctly for hotplug
> > 
> > Cc: John Stultz <johnstul@us.ibm.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > ---
> 
> Ping?

Sorry for being slow here. Looks ok to me, so I've queued this for 3.1.

thanks
-john


