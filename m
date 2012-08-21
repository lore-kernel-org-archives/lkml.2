Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2HUSsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:48:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55773 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2HUSst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:48:49 -0400
Date: Tue, 21 Aug 2012 19:52:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120821195234.20c173bc@pyramind.ukuu.org.uk>
In-Reply-To: <20120821182346.GA7325@gmail.com>
References: <1345043096.31459.106.camel@twins>
	<502BE38D.9030405@linux.intel.com>
	<20120820080606.GA6931@gmail.com>
	<20120820181651.GA737@srcf.ucam.org>
	<20120821094203.GB12385@gmail.com>
	<20120821113951.GA22436@srcf.ucam.org>
	<20120821151910.GA5359@gmail.com>
	<20120821152828.GB28241@srcf.ucam.org>
	<20120821155908.GA5499@gmail.com>
	<20120821161324.GA29665@srcf.ucam.org>
	<20120821182346.GA7325@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why? Good scheduling is useful even in isolation.

For power - I suspect it's damn near irrelevant except on a big big
machine.

Unless you've sorted out your SATA, fixed your phy handling, optimised
your desktop for wakeups and worked down the big wakeup causes one by one
it's turd polishing.

PM means fixing the stack top to bottom, and its a whackamole game, each
one you fix you find the next. You have to sort the entire stack from
desktop apps to kernel.

However benchmarks talk - so lets have some benchmarks ... on a laptop.

Alan
