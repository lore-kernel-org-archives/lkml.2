Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1DAGPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:15:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab1DAGPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:15:46 -0400
Date: Fri, 1 Apr 2011 08:15:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, stable kernel team <stable@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Michael Leun <lkml20101129@newton.leun.net>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.38.2 breaks suspend to disk
Message-ID: <20110401061524.GB32378@elte.hu>
References: <20110330203215.0a1a41a7@xenia.leun.net>
 <20110331090524.07ad0069@xenia.leun.net>
 <alpine.DEB.2.00.1103311546480.16492@kaball-desktop>
 <201103312348.53678.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103312348.53678.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Thursday, March 31, 2011, Stefano Stabellini wrote:
> > On Thu, 31 Mar 2011, Michael Leun wrote:
> > > Nope, unfortunately this does not change anything (neither when
> > > applying ontop of the tree resulting from bisecting, nor ontop
> > > 2.6.38.2).
> > > 
> > > Just to make shure there was no mistake when bisecting I did
> > > 
> > > patch -R -p1 <~/linux-2.6.38.y.git-ff518ea26654e05d325d996f6e3a7f5f569cc2d5.txt
> > > 
> > > and then indeed it worked again.
> > 
> > This patch fixes it for me.
> > 
> > 
> > ---
> > 
> > save cr4 to mmu_cr4_features at boot time
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Peter, Ingo, please regard this as urgent, it breaks -stable.

Stable team, please revert it from -stable for now.

Who pushed it to -stable so soon, just a few days after the commit has hit .39 
upstream? It was not marked -stable in the commit either.

Thanks,

	Ingo
