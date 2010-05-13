Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab0EMPx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:53:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49070 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759135Ab0EMPx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iZv87AL9e+2z8ZSTr3k/4ovcvaRWE/l5FurDDApGebwvb8rQ+1B2faHqZDv9tW8mkC
         pWXoh+qXmt5YUX3+l5lhWMWm1u0fPScLF07mgomjLElNleaMyoN1ryAYixbo8jA2sZaE
         6Jql3ZAhzgdQiNDo7bdUaMCRqdZiN/0t8dFrc=
Date: Thu, 13 May 2010 19:53:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       peterz@infradead.org, aris@redhat.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] [nmi watchdog] touch_softlockup cleanups and
	softlockup_tick removal
Message-ID: <20100513155313.GA5274@lenovo>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com> <1273266711-18706-3-git-send-email-dzickus@redhat.com> <20100512200652.GF10028@nowhere> <20100512202628.GK15159@redhat.com> <20100512202832.GG10028@nowhere> <20100512205616.GL15159@redhat.com> <20100512210034.GH10028@nowhere> <20100512213814.GB5190@lenovo> <20100512215015.GM15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512215015.GM15159@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 05:50:15PM -0400, Don Zickus wrote:
...
> > Guys, could you please spend a few minutes and enlighten me a bit?
> > Does all this series mean that we eventually will drop nmi-watchdog
> > via io-apic (read via pic) as only the transition to perf complete?
> > 
> > I recall someone said about to stop using io-apic, but just to be sure.
> 
> Right, this code sits on top of the perf subsystem which uses lapic.
> Eventually, the old nmi watchdog code will disappear along with the
> support for io-apic.
> 
> Cheers,
> Don
> 

Thanks for explanation, Don! So I assume (?) that io-apic
nmi-watchdog is going to be dropped due to obsolescense of
this mode, right?

	-- Cyrill
