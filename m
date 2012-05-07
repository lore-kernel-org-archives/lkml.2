Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2EGXvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:51:01 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:60356 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756889Ab2EGXvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:51:00 -0400
From: Kevin Hilman <khilman@ti.com>
To: Keerthy <j-keerthy@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, <j-pihet@ti.com>
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Organization: Texas Instruments, Inc.
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
Date: Mon, 07 May 2012 16:51:14 -0700
In-Reply-To: <1335462041-4949-1-git-send-email-j-keerthy@ti.com> (Keerthy's
	message of "Thu, 26 Apr 2012 23:10:31 +0530")
Message-ID: <87397by2h9.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

Keerthy <j-keerthy@ti.com> writes:

> From: J Keerthy <j-keerthy@ti.com>
>
> AVS(Adaptive Voltage Scaling) is a power management technique which
> controls the operating voltage of a device in order to optimize (i.e. reduce)
> its power consumption. The voltage is adapted depending on static factors
> (chip manufacturing process) and dynamic factors (temperature
> depending performance).
> The TI AVS solution is named Smartreflex. 
>
> To that end, create the AVS driver in drivers/power/avs and
> move the OMAP SmartReflex code to the new directory. The
> class driver is still retained in the mach-omap2 directory.

How should we handle this for upstream?

It does a bunch of cleanup under arch/arm then does the move to
drivers/power the end.  To avoid conflicts with other OMAP core changes,
I would suggest we take this through the OMAP tree.

With your ack, I'd be glad to take it.

Thanks,

Kevin

