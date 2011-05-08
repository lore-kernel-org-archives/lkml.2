Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab1EHRQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 13:16:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57700 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1EHRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 13:16:24 -0400
Date: Sun, 8 May 2011 18:16:17 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCHv3] x86, mrst: share APB timer code with other platforms
Message-ID: <20110508171617.GA2943@pulham.picochip.com>
References: <1302606630-12459-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302606630-12459-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 12:10:30PM +0100, Jamie Iles wrote:
> The APB timers are an IP block from Synopsys (DesignWare APB timers)
> and are also found in other systems including ARM SoC's.  This patch
> adds functions for creating clock_event_devices and clocksources from
> APB timers but does not do the resource allocation.  This is handled
> in a higher layer to allow the timers to be created from multiple
> methods such as platform_devices.
> 
> Changes since v2:
> 	- Make eoi() for clock_event_device optional for x86 where eoi
> 	is handled in firmware.
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

Ping?

Jamie
