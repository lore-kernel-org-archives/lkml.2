Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab1EaKud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:50:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1EaKub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:50:31 -0400
Date: Tue, 31 May 2011 12:50:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        Yann Dupont <Yann.Dupont@univ-nantes.fr>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Kernel crash after using new Intel NIC (igb)
Message-ID: <20110531105019.GF24172@elte.hu>
References: <4DDFE4D6.4010000@fb.com>
 <1306526219.2533.3.camel@edumazet-laptop>
 <20110527211419.GA6793@dev1756.snc6.facebook.com>
 <1306561285.2533.9.camel@edumazet-laptop>
 <20110528180434.GB12530@elte.hu>
 <1306654424.30021.7.camel@edumazet-laptop>
 <20110529073840.GB21254@elte.hu>
 <1306654983.30021.10.camel@edumazet-laptop>
 <20110529123318.GB26627@elte.hu>
 <4DE3E32E.5000302@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE3E32E.5000302@fb.com>
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


* Arun Sharma <asharma@fb.com> wrote:

> On 5/29/11 5:33 AM, Ingo Molnar wrote:
> >
> >* Eric Dumazet<eric.dumazet@gmail.com>  wrote:
> >
> >>I asked Arun if he wanted to make this himself, because initial
> >>idea was coming from him, not because I did not want to make it ;)
> >
> >Hey, fair enough and sorry about the fuss! :-)
> 
> Sounds like there is general consensus that such a cleanup would be 
> good. I'll try to post a patch that does this cleanup for all archs 
> in the next couple of days - but I won't have a way of testing it 
> on anything other than x86_64.

-mm is a good place to do such many-arch kind of facility 
cleanups/extensions so please Cc: Andrew if you think the patch is 
ready to be tested on that level.

Thanks,

	Ingo
