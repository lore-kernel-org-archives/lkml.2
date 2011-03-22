Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1CVKA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:00:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53995 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1CVKAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:00:22 -0400
Date: Tue, 22 Mar 2011 11:00:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110322100010.GB26130@elte.hu>
References: <20110320.195156.226769634.davem@davemloft.net>
 <AANLkTinN3qszBjbJdkXb2TPBkAW0mXGC=Ri1zKL9gdNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinN3qszBjbJdkXb2TPBkAW0mXGC=Ri1zKL9gdNg@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Mar 20, 2011 at 7:51 PM, David Miller <davem@davemloft.net> wrote:
> >
> > 1) The R8169 PHY fix from Eric Dumazet, which I see you've added to
> >   your tree too. :-)
> 
> Yeah, since my machine didn't have networking without it, and I could
> test it myself, I didn't wait to pull.
> 
> That said, I'm delaying this pull request due to the known issues with
> it - let me know when you've updated it with the fix for the
> use-after-free fixes and the slab corruptor (the latter of which I
> haven't seen a patch for yet)

All problems i was able to trigger in this area are fixed by these patches:

 ipvs: Fix a typo in __ip_vs_control_init()
 IPVS: Use global mutex in ip_vs_app.c
 ipx: Fix ipx_release()
 net/appletalk: fix atalk_release use after free

Thanks,

	Ingo
