Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1LFSFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:05:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab1LFSFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:05:48 -0500
Date: Tue, 6 Dec 2011 19:04:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ben Hutchings <ben@decadent.org.uk>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206180402.GA7080@elte.hu>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <1323193731.32012.81.camel@twins>
 <20111206175558.3215907c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111206175558.3215907c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 06 Dec 2011 18:48:51 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Tue, 2011-12-06 at 15:34 +0000, Ben Hutchings wrote:
> > > If you disagree with a patch, do not silently drop parts of it.  I
> > > demand that you remove my 'Signed-off-by' as this is not the change I
> > > submitted. 
> > 
> > The easy solution is that I never take patches from you again, ever.
> > Consider that done. I'll let Ingo see if he can remove your SOB.
> 
> In which case you are presumably ceasing to be a maintainer for that
> code ? Your statement above appears to be inconsistent with the rôle of a
> maintainer.

Just for the record, Peter is co-maintaining the lockdep code 
with me (and is doing a superb job with that) and as such he has 
no obligation whatsoever to interact with every contributor - as 
long as at least one maintainer considers every patch submitted.

Personally, reading various past discussions i can understand 
Peter not wanting to work with Ben Hutchings for some time - 
i'll look at his future patches and will consider them.

Thanks,

	Ingo
