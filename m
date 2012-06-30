Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2F3X5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 19:57:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:33541 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab2F3X5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 19:57:07 -0400
Message-ID: <1341100552.2563.48.camel@pasglop>
Subject: Re: [PATCH 13/40] autonuma: CPU follow memory algorithm
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nai Xia <nai.xia@gmail.com>
Cc: dlaor@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>
Date: Sun, 01 Jul 2012 09:55:52 +1000
In-Reply-To: <CAPQyPG50wtowNsPm1UADCNchY-gFk-cKW8oiU34L2REybhNoEg@mail.gmail.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
	 <1340888180-15355-14-git-send-email-aarcange@redhat.com>
	 <1340895238.28750.49.camel@twins>
	 <CAJd=RBA+FPgB9iq07YG0Pd=tN65SGK1ifmj98tomBDbYeKOE-Q@mail.gmail.com>
	 <20120629125517.GD32637@gmail.com> <4FEDDD0C.60609@redhat.com>
	 <1340995986.28750.114.camel@twins>
	 <CAPQyPG4R34bi0fXHBspSpR1+gDLj2PGYpPXNLPTTTBmrRL=m4g@mail.gmail.com>
	 <20120630012338.GY6676@redhat.com>
	 <CAPQyPG7Nx1Jdq7WBBDC41iRGOMx8CdQjcWTNOWyj1fzVeuRcgw@mail.gmail.com>
	 <4FEE9310.1050908@redhat.com>
	 <CAPQyPG50wtowNsPm1UADCNchY-gFk-cKW8oiU34L2REybhNoEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-30 at 14:58 +0800, Nai Xia wrote:
> If you insist on ignoring any constructive suggestions from others,

But there is nothing constructive about your criticism.

You are basically saying that the whole thing cannot work unless it's
based on 20 years of research. Duh !

Ben.


