Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1KUTCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:02:00 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:55450
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab1KUTB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:01:58 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.135;KIP:(null);UIP:(null);IPV:NLI;H:kedge3.utk.tennessee.edu;RD:kedge3.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 21 Nov 2011 14:01:51 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <mingo@redhat.com>, <hpa@zytor.com>, <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf/x86: Enable raw event access to Intel
 offcore events
In-Reply-To: <1321901536.28118.20.camel@twins>
Message-ID: <alpine.DEB.2.00.1111211358570.23676@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>  <tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>  <alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu> <1321901536.28118.20.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Peter Zijlstra wrote:
> On Mon, 2011-11-21 at 13:24 -0500, Vince Weaver wrote:

> > Now I'll have to find something else 
> > to complain about, probably the scedulability issue introduced with the
> > NMI watchdog.
> 
> But you can disable that thing, right?
> 
> echo 0 > /proc/sys/kernel/nmi_watchdog;
> 
> or so should do the trick.

yes, if the user running PAPI has root.

That's unfortunately not always the case, and sometimes people want to 
have both the NMI watchdog operating and use PAPI simultaneously.

We have a workaround, but it currently disables kernel multiplexing and a 
few other nice features.

Vince
vweaver1@eecs.utk.edu

