Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab1BWUyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:54:37 -0500
Received: from www.tglx.de ([62.245.132.106]:60850 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab1BWUyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:54:35 -0500
Date: Wed, 23 Feb 2011 21:54:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sergei Shtylyov <sshtylyov@mvista.com>
cc: Pratheesh Gangadhar <pratheesh@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com, amit.chatterjee@ti.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, hjk@hansjkoch.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] PRUSS UIO driver support
In-Reply-To: <4D6572ED.9020805@mvista.com>
Message-ID: <alpine.LFD.2.00.1102232153500.2701@localhost6.localdomain6>
References: <1298469161-7644-1-git-send-email-pratheesh@ti.com> <1298469161-7644-2-git-send-email-pratheesh@ti.com> <alpine.LFD.2.00.1102232057260.2701@localhost6.localdomain6> <4D6572ED.9020805@mvista.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Sergei Shtylyov wrote:
> Hello.
> 
> On 23-02-2011 23:25, Thomas Gleixner wrote:
> 
> > > +	prussio_virt_addr =
> > > +	    ioremap(regs_prussio->start,
> > > +		    regs_prussio->end - regs_prussio->start + 1);
> 
> > Either make those variable names shorter or do:
> 
> >         len = regs_prussio->end - regs_prussio->start + 1;
> 
>    Or even:
> 
> 	len = resource_size(regs_prussio);
> 
> >         prussio_virt_addr = ioremap(regs_prussio->start, len);

Good point. Forgot about that one :)

Thanks,

	tglx
