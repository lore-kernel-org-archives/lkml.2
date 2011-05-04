Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab1EDBAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 21:00:48 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52727 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1EDBAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 21:00:47 -0400
Subject: Re: Long timeout when booting >= 2.6.38
From: john stultz <johnstul@us.ibm.com>
To: Christian Hoffmann <email@christianhoffmann.info>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4DBF2FB4.8000304@christianhoffmann.info>
References: <4DBEFCBA.3070501@christianhoffmann.info>
	 <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>
	 <1304372955.3226.15.camel@work-vm>
	 <4DBF2FB4.8000304@christianhoffmann.info>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 18:00:39 -0700
Message-ID: <1304470839.3037.12.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 00:27 +0200, Christian Hoffmann wrote:
> On 05/02/2011 11:49 PM, john stultz wrote:
> > On Mon, 2011-05-02 at 22:42 +0200, Christian Hoffmann wrote:
> >> Hi,
> >>
> >>> Hrm. So, on older kernels, what do you see from:
> >>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> >>> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> >>
> >> On older and newer kernel I see the same output:
> >> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> >> tsc
> >> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> >> tsc hpet acpi_pm
> >
> > Can you reproduce the hang booting with "clocksource=hpet" and
> > "clocksource=acpi_pm" ?
> 
> Both hang also.

Sorry, one more clarifying point here:

When you used either clocksource=hpet/clocksource=acpi_pm did the
behavior of the system seem different after booting? In other words:
does running time waiting a few seconds and then running time again show
the expected passage of time?  Were any following hangs seen, or was it
only the first one at boot?



thanks
-john


