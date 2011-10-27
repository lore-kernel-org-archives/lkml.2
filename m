Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1J0GAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 02:00:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1J0GA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 02:00:29 -0400
Date: Thu, 27 Oct 2011 07:48:06 +0200
From: Greg KH <gregkh@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: miche@google.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: Regression: patch " hvc_console: display printk messages on
 console." causing infinite loop with 3.2-rc0 + Xen.
Message-ID: <20111027054806.GA1377@suse.de>
References: <20111027053007.GA32765@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027053007.GA32765@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:30:08AM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Miche.
> 
> The git commit 361162459f62dc0826b82c9690a741a940f457f0:
> 
>     hvc_console: display printk messages on console.
> 
> is causing an infinite loop when booting Linux under Xen, as so:
> 
> [    2.382984] console [hvc0] enabled
> [    2.382984] console [hvc0] enabled
> [    2.382984] console [hvc0] enabled
> [    2.382984] console [hvc0] enabled
> [    2.382984] console [hvc0] enabled
> [    2.382984] console [hvc0] enabled
> .. 
> 
> (see attached file titled bad.log)
> 
> If I use Linus's latest git tree and revert your patch I get the kernel
> to bootup (see good.log file),

Ick, not good, thanks for letting us know.

Miche, want me to just revert this, or do you think you can fix it?

thanks,

greg k-h
