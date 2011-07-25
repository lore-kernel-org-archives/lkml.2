Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1GYLeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:34:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41359 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1GYLdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:33:55 -0400
Date: Mon, 25 Jul 2011 13:32:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725113258.GA26133@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725103817.GA21683@infradead.org>
 <20110725110809.GO28787@elte.hu>
 <20110725112412.GA1429@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725112412.GA1429@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jul 25, 2011 at 01:08:10PM +0200, Ingo Molnar wrote:
>
> > Fact is that developing ABIs within an integrated project is 
> > *amazingly* powerful. You should try it one day, instead of 
> > criticizing it :-)
> 
> I've been doing this long before you declare it the rosetta stone.  
> Some of the worst ABIs I know come from that kind of development, 
> e.g. all the ioctls we have in xfs, inherited from the "tightly 
> integrated" IRIX development cycle.

As i said it's not a guarantee, you can mess up even under the best 
of circumstances.

Also, arguably a filesystem is constrainted wrt. ABIs: it's just one 
filesystem which pretty much pushes it towards ioctls which in turn 
is often an unstructured breeding ground for mess.

Thanks,

	Ingo
