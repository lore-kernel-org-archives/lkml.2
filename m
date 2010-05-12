Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab0ELVic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:38:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:19261 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002Ab0ELVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rpj3+ea2CuoFGKvkFQuRMAhiwRc7Mk3mN8iOLT5sWVEZ/xEAR9dAg37tgnGjAnkqb+
         Y+B5/qTWGqrxSizW9f2/3qt9rUqMBOdp7JW6ZN1YzOwZJzRtuK3eOfUvdSTak0JCEUoE
         Kx27TPYBwOaM24QFsD3zSxejyvHpDU40fnjIE=
Date: Thu, 13 May 2010 01:38:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu
Cc: Don Zickus <dzickus@redhat.com>, peterz@infradead.org, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] [nmi watchdog] touch_softlockup cleanups and
	softlockup_tick removal
Message-ID: <20100512213814.GB5190@lenovo>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com> <1273266711-18706-3-git-send-email-dzickus@redhat.com> <20100512200652.GF10028@nowhere> <20100512202628.GK15159@redhat.com> <20100512202832.GG10028@nowhere> <20100512205616.GL15159@redhat.com> <20100512210034.GH10028@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512210034.GH10028@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:00:36PM +0200, Frederic Weisbecker wrote:
...
> > > 
> > > Ah right.
> > > 
> > > BTW, if you address my reviews, please do it incrementally, I'm going
> > > to apply this set and push it to Ingo.
> > 
> > Ok, probably easier to review too. :-)
> 
> 
> Yeah, and it's time to flush this code as it's good globally.
> 
> Plus it would be nice to get this for .35
> 
> Ah and forget about the sysctl ABI breakages. Since this is only
> used for kernel development, this is not going to break much things.
> If somebody complains, we can still reintegrate what we had.
> 
> Thanks.
> 
...
Guys, could you please spend a few minutes and enlighten me a bit?
Does all this series mean that we eventually will drop nmi-watchdog
via io-apic (read via pic) as only the transition to perf complete?

I recall someone said about to stop using io-apic, but just to be sure.

	-- Cyrill
