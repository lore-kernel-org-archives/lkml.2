Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1AYK1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:27:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43811 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1AYK1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:27:06 -0500
Date: Tue, 25 Jan 2011 10:26:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: sen wang <wangchendu@gmail.com>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: questions about arm trustzone
Message-ID: <20110125102652.GB11507@n2100.arm.linux.org.uk>
References: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com> <8yad3nlh18e.fsf@huya.qualcomm.com> <AANLkTin9fSw5DdqdgCEvtdtc83LFOeA7t0OAUugVmRFD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin9fSw5DdqdgCEvtdtc83LFOeA7t0OAUugVmRFD@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 05:19:16PM +0800, sen wang wrote:
> It seems linux run in the normal world, and the "scm.c"  is the path
> to the monitor mode.
> where can I find the example code for monitor and secure world?

OMAP also uses smc: arch/arm/mach-omap2/omap44xx-smc.S

There's no interface defined for smc because it's highly vendor and
implementation specific.  It's just like a SWI (or svc) where it
causes entry via a vector into a priviledged mode, which can be
thought of being similar to a branch to a vector with a mode switch.
