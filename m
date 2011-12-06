Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1LFSXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:23:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab1LFSXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:23:50 -0500
Date: Tue, 6 Dec 2011 18:23:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Bowler <nbowler@elliptictech.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Message-ID: <20111206182337.GH3366@decadent.org.uk>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <20111206175443.GB25031@elte.hu>
 <20111206181422.GA11881@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206181422.GA11881@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 01:14:22PM -0500, Nick Bowler wrote:
> On 2011-12-06 18:54 +0100, Ingo Molnar wrote:
[...]
> > Once you send it out the SOB is valid and people can (and 
> > typically will) modify it - and if you are still the main author 
> > (which you are here 100%) then keeping you as the author is the 
> > proper approach - Peter added his own SOB after yours.
> 
> Linux convention is to add a signoff *and* a description of any changes
> to the original submission in square brackets.

Yes, I would also be satisfied with that.  (So my 'demand' was a bit
overstated.  Sorry about that, but *quietly* changing my code is like
misquoing me and it does get me pretty angry.)
 
Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
