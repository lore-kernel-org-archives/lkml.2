Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0IOTel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:34:41 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60898 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab0IOTek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RXwJkhLkrGvveLBL3sM7PzdaobSeFb84R0MO1pG4jGioRnxrsT+uUSxdoxoQJrCP4Y
         9yG3WmkOmwYCCUscmqFbM/A43lhKcnopiDdGXD5KkS/q/j/BUkg1A+LHjWm+FODi3mPs
         8Rid+bDyEBMSLYkJYkkajwm7y9btc8qbmWA68=
Date: Wed, 15 Sep 2010 23:34:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
	counters
Message-ID: <20100915193437.GA28455@lenovo>
References: <20100911114404.GE13563@erda.amd.com> <20100911124537.GA22850@elte.hu> <20100912095202.GF13563@erda.amd.com> <20100913143713.GK13563@erda.amd.com> <20100914174132.GN13563@erda.amd.com> <20100915162034.GO13563@erda.amd.com> <AANLkTimWoE5XiYSr8jx=RFS5Nb9d4_wWe=c-W3oMj8dH@mail.gmail.com> <20100915170057.GQ13563@erda.amd.com> <AANLkTi=yvDF34e5rYqJt=Av7dhSwBLjXp=r_EfEAMLJY@mail.gmail.com> <20100915184424.GS13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915184424.GS13563@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 08:44:24PM +0200, Robert Richter wrote:
...
> 
> Do you know at which period the counters running for the following?
> 
>  perf record ./hackbench 10
>  perf record -e cycles -e instructions -e cache-references \
>      -e cache-misses -e branch-misses -a -- <cmd>
> 
> I couldn't find something about this in the man page.
> 

It's on top of tools/perf/builtin-record.c so by default they
should be sampled with frequency 1KHz. Frederic or Peter knows
for sure ;)

	-- Cyrill
