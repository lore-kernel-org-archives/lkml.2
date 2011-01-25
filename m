Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1AYLyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:54:41 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:60217 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198Ab1AYLyk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:54:40 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jan 2011 06:54:39 EST
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com><8yad3nlh18e.fsf@huya.qualcomm.com><AANLkTin9fSw5DdqdgCEvtdtc83LFOeA7t0OAUugVmRFD@mail.gmail.com>
 <20110125102652.GB11507@n2100.arm.linux.org.uk>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acu8eoCdV0DHmxnGRka9YNLNH/Y0NAACmf4A
In-Reply-To: <20110125102652.GB11507@n2100.arm.linux.org.uk>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Tue, 25 Jan 2011 17:16:19 +0530
Message-ID: <bb0c3855a121603232d022b4062752a6@mail.gmail.com>
Subject: RE: questions about arm trustzone
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        sen wang <wangchendu@gmail.com>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-
> arm-kernel-bounces@lists.infradead.org] On Behalf Of Russell King -
> ARM Linux
> Sent: Tuesday, January 25, 2011 3:57 PM
> To: sen wang
> Cc: David Brown; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: questions about arm trustzone
>
> On Tue, Jan 25, 2011 at 05:19:16PM +0800, sen wang wrote:
> > It seems linux run in the normal world, and the "scm.c"  is the
> path
> > to the monitor mode.
> > where can I find the example code for monitor and secure world?
>
> OMAP also uses smc: arch/arm/mach-omap2/omap44xx-smc.S
>
> There's no interface defined for smc because it's highly vendor and
> implementation specific.  It's just like a SWI (or svc) where it
> causes entry via a vector into a priviledged mode, which can be
> thought of being similar to a branch to a vector with a mode switch.
>
The code above won't give major details of how the monitor mode is
implemented.  But as Russell said, it's pretty much vendor specific.

On OMAP, We have standard API interfaces to enter into monitor
world. One of the parameter denotes the kind of service, is
requested.

Regards,
Santosh
