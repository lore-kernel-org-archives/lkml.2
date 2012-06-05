Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2FEFMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 01:12:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63759 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2FEFMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 01:12:07 -0400
Date: Tue, 5 Jun 2012 13:11:44 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot
 secondary processors
Message-ID: <20120605051144.GA4064@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
 <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com>
 <20120601165113.GA18870@merkur.ravnborg.org>
 <4FC9424E.9060009@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206041228330.3086@ionos>
 <4FCCB31B.6060302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FCCB31B.6060302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 06:37:39PM +0530, Srivatsa S. Bhat wrote:
> On 06/04/2012 04:02 PM, Thomas Gleixner wrote:
> >> However, I do want to emphasize that this isn't generic code. So how about
> >> an "arch_" prefix instead? Something like:
> >> arch_cpu_pre_starting(), arch_cpu_pre_online() and arch_cpu_post_online()?
> > 
> > Yes, please.
> 
> 
> Sure, queued up for v2. (Atm, figuring out how to deal with xen (patch 5). Once
> that gets done, will post a v2.)

Since there is dependency on ipi_call_lock cleanup patches
http://marc.info/?l=linux-kernel&m=133827595625509&w=2

So please feel free to include the patches into yours.

And It will be better that Thomas could pick them up :)

Thanks,
Yong

> 
> > 
> > Otherwise, thanks for that work!
> 
> 
> We are glad that it helps :-)
> 
> > From the first glance, it's not
> > colliding much with the changes I have in the pipeline, but I will
> > have a closer look.
> > 
> 
> 
> Great! Thanks a lot for your time, Thomas!
>  
> Regards,
> Srivatsa S. Bhat
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
