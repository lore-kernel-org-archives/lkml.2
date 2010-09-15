Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0IOUjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 16:39:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45037 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab0IOUjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 16:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rPXRw1knfjVBpcS41naoBLxkLtLBsJbmRayeI0Jp5m2r+Ys5aJ6NufkoHYDjlDUyZY
         3j02NGJJ7mVTPYL8dBxgp8U3eEi2szg/Tsmpv40FeOvN3qXTqjbICNXI5tTfl46KSX0B
         Rm3Z3tNK69XWPjBrbhvibW0Sys5FJ4kXTwnok=
Date: Thu, 16 Sep 2010 00:39:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
	counters
Message-ID: <20100915203948.GB28455@lenovo>
References: <20100912095202.GF13563@erda.amd.com> <20100913143713.GK13563@erda.amd.com> <20100914174132.GN13563@erda.amd.com> <20100915162034.GO13563@erda.amd.com> <AANLkTimWoE5XiYSr8jx=RFS5Nb9d4_wWe=c-W3oMj8dH@mail.gmail.com> <20100915170057.GQ13563@erda.amd.com> <AANLkTi=yvDF34e5rYqJt=Av7dhSwBLjXp=r_EfEAMLJY@mail.gmail.com> <20100915184424.GS13563@erda.amd.com> <20100915193437.GA28455@lenovo> <AANLkTimPh7bo1XxTK8bnisvLq8pCySUV6XJspw8m-Wwa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimPh7bo1XxTK8bnisvLq8pCySUV6XJspw8m-Wwa@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 10:21:10PM +0200, Stephane Eranian wrote:
> When you do perf record foo, it's equivalent to
> perf record -e cycles:uk -F 1000 foo
>

yup, thanks
 
> I think there is a problem with perf record in case you provide
> multiple events. It is going to sample on all of them at the same
> frequency. You may not always want that, but I don't think there
> is a way to change that.
> 

indeed, without perf-tool code changes but i think you still may run
multiple instances of perf-tool :)

