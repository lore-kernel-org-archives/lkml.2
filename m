Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1AYMAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:00:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50889 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1AYMAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:00:32 -0500
Date: Tue, 25 Jan 2011 12:00:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: sen wang <wangchendu@gmail.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: questions about arm trustzone
Message-ID: <20110125120013.GH11507@n2100.arm.linux.org.uk>
References: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com> <8yad3nlh18e.fsf@huya.qualcomm.com> <AANLkTin9fSw5DdqdgCEvtdtc83LFOeA7t0OAUugVmRFD@mail.gmail.com> <20110125102652.GB11507@n2100.arm.linux.org.uk> <bb0c3855a121603232d022b4062752a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb0c3855a121603232d022b4062752a6@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 05:16:19PM +0530, Santosh Shilimkar wrote:
> The code above won't give major details of how the monitor mode is
> implemented.  But as Russell said, it's pretty much vendor specific.
> 
> On OMAP, We have standard API interfaces to enter into monitor
> world. One of the parameter denotes the kind of service, is
> requested.

In much the same way as we do with r7 with the kernels userspace syscall
interface via swi/svc.
