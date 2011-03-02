Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab1CBTCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:02:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54067 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab1CBTCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:02:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DAMmWk5Q3Ox6gWHJIQa6qb3b5VEPRr35Q8/AbcHhGUPPwlCxSO0vUu4Vs8elhZLXU+
         OygGmYr/6WYDSo/7K1J51JCYx8bnTzsUGO8i9/ZmSBZgGxj16k/PxhmgMOExG/7aj55E
         aRvQgF51+JIcOOn+bK+3ZX15WZ8a81Rzu0hOQ=
Date: Wed, 2 Mar 2011 20:02:08 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110302190208.GD28266@mtj.dyndns.org>
References: <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <4D6E6D52.8030901@kernel.org>
 <20110302163729.GQ3319@htj.dyndns.org>
 <4D6E7459.6050706@kernel.org>
 <20110302165545.GR3319@htj.dyndns.org>
 <4D6E91EC.6040906@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E91EC.6040906@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Yinghai.

On Wed, Mar 02, 2011 at 10:52:28AM -0800, Yinghai Lu wrote:
> > Complexity of a solution should match the benefit of the complexity.
> > Code complexity is one of the most important metrics that we need to
> > keep an eye on.  If you don't do that, the code base becomes very ugly
> > and difficult to maintain very quickly.  So, yes, some amount of
> > execution inefficiency is acceptable depending on circumstances.
> > Efficiency too is something which should be traded off against other
> > benefits.
> 
> No. it is not acceptable in your case.
> 
> We can accept that something like: during init stage, do some probe
> and call pathes to be happy.  like subarch.

Hmmm?  I can't really follow your sentence.  This is init stage.
Anyways, why can't it just walk over the enabled nodes?  What would be
the difference?

> Also why did you omit my first question?

Yeah, well, because that wasn't completely consistent with what I said
earlier.  I wanted to tell you to take the assignments out of if () on
your earlier patch but I just let it pass and now I had this another
patch touching the same code, so I just had to do it.

I know it's a petty style thing but it's my pet peeve and I can't help
it when related change goes through me, so there it is.  I'm sorry but
I'll probaly do it again.  I beg your understanding.

Thank you.

-- 
tejun
