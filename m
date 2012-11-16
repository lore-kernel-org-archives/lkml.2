Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab2KPNQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:16:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:46263 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2KPNQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:16:38 -0500
Date: Fri, 16 Nov 2012 05:17:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chintan Pandya <cpandya@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: sysfs crashes while recursively checking file permissions
Message-ID: <20121116131728.GA30613@kroah.com>
References: <50937B34.6050502@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50937B34.6050502@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 01:20:12PM +0530, Chintan Pandya wrote:
> Hi,
> 
> I am running one test on my ARM system which checks the sysfs file
> system's whole directory recursively and checks its file permission.
> While I perform this test, I face random (as in varies the nature of
> crash sometimes) crashes like one mentioned below.
> 
> 
> <1>[   67.442660] Unable to handle kernel paging request at virtual
> address efd3d794
> 
> <1>[   67.448840] pgd = da364000
> 
> <1>[   67.451529] [efd3d794] *pgd=00000000
> 
> <0>[   67.455092] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> 
> <4>[   67.460385] Modules linked in:
> 
> <4>[   67.463424] CPU: 1    Not tainted
> (3.4.0-perf-g45c04fe-00006-g8a5c5e2 #27)

Can you try a newer kernel version?  Like 3.7-rc5?  3.6.6?

thanks,

greg k-h
