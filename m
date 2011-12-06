Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1LFSRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:17:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51106 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab1LFSRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:17:31 -0500
Date: Tue, 6 Dec 2011 18:17:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Message-ID: <20111206181715.GG3366@decadent.org.uk>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <1323193731.32012.81.camel@twins>
 <20111206175558.3215907c@lxorguk.ukuu.org.uk>
 <20111206175919.GA5386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111206175919.GA5386@elte.hu>
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

On Tue, Dec 06, 2011 at 06:59:19PM +0100, Ingo Molnar wrote:
> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > On Tue, 06 Dec 2011 18:48:51 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Tue, 2011-12-06 at 15:34 +0000, Ben Hutchings wrote:
> 
> > > > If you disagree with a patch, do not silently drop parts 
> > > > of it.  I demand that you remove my 'Signed-off-by' as 
> > > > this is not the change I submitted.
> > > 
> > > The easy solution is that I never take patches from you 
> > > again, ever. Consider that done. I'll let Ingo see if he can 
> > > remove your SOB.
> > 
> > In which case you are presumably ceasing to be a maintainer 
> > for that code ? Your statement above appears to be 
> > inconsistent with the rôle of a maintainer.
> 
> What Peter did was rather sensible: he split a patch that did 
> two things into two and applied one standalone, uncontroversial 
> half of it and kept the part of the part of the changelog that 
> related to that change.
[...]

I can accept that if the change from my submission is commented
in the commit message.  (I sometimes do that with other people's
patches.)  But this was modified without comment.

Giving credit for authorship is important, but it is also
important not to say someone is the sole author of something
when they aren't and haven't approved the subsequent changes
(cf. Alan Smithee).
 
Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
