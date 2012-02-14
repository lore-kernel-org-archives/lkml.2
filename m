Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab2BNUBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:01:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:58326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab2BNUBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:01:03 -0500
Message-ID: <1329249629.2293.22.camel@twins>
Subject: Re: smp: Start up non-boot CPUs asynchronously
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjanvandeven@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, mikey@neuling.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        gregkh@linuxfoundation.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 14 Feb 2012 21:00:29 +0100
In-Reply-To: <4F3ABCC1.5020000@linux.vnet.ibm.com>
References: <20120130205444.22f5e26a@infradead.org>
	 <20120131125232.GD4408@elte.hu>	<20120131054155.371e8307@infradead.org>
	 <20120131143130.GF13676@elte.hu>	<20120131072216.1ce78e50@infradead.org>
	 <20120131161207.GA18357@elte.hu>	<20120131082439.575978c0@infradead.org>
	 <4F3A1891.8060001@linux.vnet.ibm.com>	<4F3A2DFB.5000209@linux.vnet.ibm.com>
	 <CADyApD0o4UYsTkqf2H2yJZ-d05NAyRAEc6z+m1gJEogc=cZLqQ@mail.gmail.com>
	 <4F3ABCC1.5020000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 01:27 +0530, Srivatsa S. Bhat wrote:
> [Small note, it appears as if the last 2 of your replies to this
> thread
>  didn't reach LKML.] 

because he used html mail, LKML drops those.. IIRC you can tell K-9 not
to use html cruft, but then I stopped trying to pretend you can email
using phones, its all too painful.
