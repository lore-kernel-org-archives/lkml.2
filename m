Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab0E1PKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:10:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59558 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab0E1PKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MlIpTVPsbImBLhMQhlYITtG7jd5nWM9R9UO5A6nBGgh2fpkoNX8KJL5AzMVKE8IqLc
         sb8cBvPkcZl5zRkm3cU/ApBeN8p0gWVJVagYcRsqboMUt2l2HH+Sj4GgK+LzWogJdVU6
         pG0FOP2E2p6d1rYCkRiy9b6oyl/CIser5KrsI=
Date: Sat, 29 May 2010 00:03:56 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-ID: <20100528150356.GA12035@barrios-desktop>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
 <AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
 <20100528145329.7E2D.A69D9226@jp.fujitsu.com>
 <20100528125305.GE11364@uudg.org>
 <20100528140623.GA11041@barrios-desktop>
 <20100528142048.GF5579@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528142048.GF5579@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 07:50:48PM +0530, Balbir Singh wrote:
> * MinChan Kim <minchan.kim@gmail.com> [2010-05-28 23:06:23]:
> 
> > > I confess I failed to distinguish memcg OOM and system OOM and used "in
> > > case of OOM kill the selected task the faster you can" as the guideline.
> > > If the exit code path is short that shouldn't be a problem.
> > > 
> > > Maybe the right way to go would be giving the dying task the biggest
> > > priority inside that memcg to be sure that it will be the next process from
> > > that memcg to be scheduled. Would that be reasonable?
> > 
> > Hmm. I can't understand your point. 
> > What do you mean failing distinguish memcg and system OOM?
> > 
> > We already have been distinguish it by mem_cgroup_out_of_memory.
> > (but we have to enable CONFIG_CGROUP_MEM_RES_CTLR). 
> > So task selected in select_bad_process is one out of memcg's tasks when 
> > memcg have a memory pressure. 
> >
> 
> We have a routine to help figure out if the task belongs to the memory
> cgroup that cause the OOM. The OOM entry from memory cgroup is
> different from a regular one. 

I meant it. 
My english is poor. "out of" isn't proper. 

> 
> -- 
> 	Three Cheers,
> 	Balbir

-- 
Kind regards,
Minchan Kim
