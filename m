Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0JZIJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:09:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab0JZIJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:09:08 -0400
Date: Tue, 26 Oct 2010 10:08:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for October 6
Message-ID: <20101026080822.GA10520@elte.hu>
References: <20101006163632.c1943a38.sfr@canb.auug.org.au>
 <AANLkTimb2NxXcfj-o=F18S1u2rn-o851F+1sgQ_2uOVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimb2NxXcfj-o=F18S1u2rn-o851F+1sgQ_2uOVQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:

> 2010/10/6 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > Changes since 20101005:
> 
> It looka like a bug or a beetle or something like that
> 
> /home/test/linux-2.6/fs/nfs/nfsroot.c: In function 'nfs_root_debug':
> /home/test/linux-2.6/fs/nfs/nfsroot.c:110:2: error: 'nfs_debug'
> undeclared (first use in this function)
> /home/test/linux-2.6/fs/nfs/nfsroot.c:110:2: note: each undeclared
> identifier is reported only once for each function it appears in
> make[3]: *** [fs/nfs/nfsroot.o] Error 1
> make[2]: *** [fs/nfs] Error 2
> make[1]: *** [fs] Error 2
> make: *** [sub-make] Error 2

This build bug has now been pushed upstream and triggers rather easily. Trond?

Thanks,

	Ingo
