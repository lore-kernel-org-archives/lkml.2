Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2FFOb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:31:27 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:43369
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941Ab2FFOb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:31:26 -0400
X-Forefront-Antispam-Report: CIP:160.36.179.112;KIP:(null);UIP:(null);IPV:NLI;H:kedge2.utk.tennessee.edu;RD:kedge2.utk.tennessee.edu;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz936eI1432N98dKzz1202hzz8275dhz2dh87h2a8h668h839h8e2h8e3h944he96hbe9i)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 6 Jun 2012 10:30:32 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
X-X-Sender: vweaver1@ig.icl.utk.edu
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <paulus@samba.org>,
        <acme@ghostprotocols.net>
Subject: Re: [perf] exporting perf_pmu_register?
In-Reply-To: <1338979285.2749.94.camel@twins>
Message-ID: <alpine.LRH.2.00.1206061027420.37035@ig.icl.utk.edu>
References: <alpine.DEB.2.00.1203151737430.15513@cl320.eecs.utk.edu> <1338979285.2749.94.camel@twins>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Peter Zijlstra wrote:

> On Thu, 2012-03-15 at 17:41 -0400, Vince Weaver wrote:
> > Would a patch similar to
> >   https://lkml.org/lkml/2010/8/18/64
> > be accepted that exported this?
> > 
> If it comes with a patch that uses the exports, sure.
> 

while I understand the logic behind that from a kernel-developer 
perspective, it does make things harder in the real world.

In the end PAPI has implemented RAPL support via reading /dev/cpu/*/msr
because it was easier to convince our sysadmin to give us read-only 
permission to /dev/cpu/*/msr than to take our in-production Sandybridge-EP 
system and patch it up to export perf_pmu_register so we could work on a 
proper driver.

Vince

