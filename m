Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2HPIRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:17:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab2HPIRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:17:18 -0400
Message-ID: <1345105019.29668.0.camel@twins>
Subject: Re: [PATCH v3] Hardware breakpoints: Invoke __perf_event_disable()
 if interrupts are already disabled
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        prasad.krishnan@gmail.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, paulus@samba.org, acme@ghostprotocols.net,
        emachado@linux.vnet.ibm.com
Date: Thu, 16 Aug 2012 10:16:59 +0200
In-Reply-To: <20120815184216.GC19716@somewhere>
References: <20120731134124.GD17078@somewhere.redhat.com>
	 <20120802081635.5811.17737.stgit@localhost.localdomain>
	 <502BDE3D.6070909@linux.vnet.ibm.com> <20120815184216.GC19716@somewhere>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 20:42 +0200, Frederic Weisbecker wrote:
> On Wed, Aug 15, 2012 at 11:07:01PM +0530, Naveen N. Rao wrote:
> > Hi Frederick,
> > Did you get a chance to take a look at this?
> > 
> > Regards,
> > Naveen
> 
> Yeah, I'm ok with the patch. Peter, are you ok with it?

Yeah, queued, it. sorry for loosing track etc..
