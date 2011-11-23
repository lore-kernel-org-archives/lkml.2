Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776Ab1KWDwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:52:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:5393 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab1KWDwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:52:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,557,1315206000"; 
   d="scan'208";a="78227753"
Subject: Re: 3.1+ iwlwifi lockup
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111123033446.GB9703@redhat.com>
References: <20111031143408.GA17152@redhat.com>
	 <1321992902.8072.7.camel@wwguy-ubuntu> <20111123024545.GA9703@redhat.com>
	 <1322015380.11647.82.camel@wwguy-huron>  <20111123033446.GB9703@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 18:56:05 -0800
Message-ID: <1322016965.11647.95.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 19:34 -0800, Dave Jones wrote:
> On Tue, Nov 22, 2011 at 06:29:40PM -0800, Guy, Wey-Yi wrote:
>  
>  > On Tue, 2011-11-22 at 18:45 -0800, Dave Jones wrote:
>  > > On Tue, Nov 22, 2011 at 12:15:02PM -0800, wwguy wrote:
>  > >  > Hi Dave,
>  > >  > 
>  > >  > Sorry for taking so long.
>  > >  > it is a bogus command from the firmware which driver try to process it
>  > >  > and cause problem. I am not sure how it happen. But could you please try
>  > >  > the patch I attach here.
>  > >  > 
>  > >  > For now I am just ignore the command, but not sure it is good enough,
>  > >  > might has to reload the firmware, but not sure.
>  > > 
>  > > With Linus' current tree and this patch, I got a panic pretty quickly,
>  > > but with a different trace.
>  > > 
>  > Are you seeing the problem without this patch? I guess the patch I done
>  > here is not the right thing to do and I try to address the problem too
>  > aggressively
> 
> I've been running Linus' current tree for the whole time and haven't seen
> any iwlwifi traces since my initial report on the 11th.
> 
> I can't reproduce the bug, even by doing the same operation
> (an scp of a dozen photographs).
> 
> It seems to happen almost at random, as if it's somehow timing related.
> I'm running the patched kernel again now, and it's been fine for the last hour.
> 
Agree, that is why I could not re-produce here after many try. Could you
share your configuration, such as band/channel, 32/64 bit system, 20/40
MHz, traffic type, open/security, power management, ..., 

Thanks
Wey
> 


