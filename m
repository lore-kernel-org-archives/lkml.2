Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0IQUv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:51:28 -0400
Received: from www.tglx.de ([62.245.132.106]:49086 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab0IQUv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:51:27 -0400
Date: Fri, 17 Sep 2010 22:51:19 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uio: Cleanup irq handling.
Message-ID: <20100917205119.GC2522@local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <m1k4mo893j.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009172234060.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009172234060.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:34:49PM +0200, Thomas Gleixner wrote:
> On Tue, 14 Sep 2010, Eric W. Biederman wrote:
> 
> > 
> > Change the value of UIO_IRQ_NONE -2 to 0.  0 is well defined in the rest
> > of the kernel as the value to indicate an irq has not been assigned.
> > 
> > Update the calls to request_irq and free_irq to only ignore UIO_IRQ_NONE
> > and UIO_IRQ_CUSTOM allowing the rest of the kernel's possible irq
> > numbers to be used.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>  
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

