Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab1D2Jew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 05:34:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:57100 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1D2Jev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 05:34:51 -0400
Date: Fri, 29 Apr 2011 11:34:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: sedat.dilek@gmail.com, john stultz <johnstul@us.ibm.com>,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
In-Reply-To: <20110429004255.GF2191@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1104291133100.3005@ionos>
References: <BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com> <alpine.LFD.2.02.1104282044120.3005@ionos> <20110428222301.0b745a0a@neptune.home> <alpine.LFD.2.02.1104282227340.3005@ionos> <20110428224444.43107883@neptune.home> <alpine.LFD.2.02.1104282251080.3005@ionos>
 <1304027480.2971.121.camel@work-vm> <alpine.LFD.2.02.1104282353140.3005@ionos> <BANLkTi=uDstjKEQaPOkxX94NxMQU2Pu5gA@mail.gmail.com> <BANLkTikS-PN0PDBbCz3emWRBL90sGMY+Kg@mail.gmail.com> <20110429004255.GF2191@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011, Paul E. McKenney wrote:
> On Fri, Apr 29, 2011 at 01:35:44AM +0200, Sedat Dilek wrote:
> >  01:35:17 up 45 min,  3 users,  load average: 0.45, 0.57, 1.27
> > 
> > Thanks to all involved people helping to kill that bug (Come on Paul, smile!).
> 
> Woo-hoo!!!!
> 
> Many thanks to Thomas for tracking this down -- it is fair to say that
> I never would have thought to look at timer initialization!  ;-)

Many thanks to the reporters who provided all the information and
tested all the random debug patches we threw at them !

       tglx
