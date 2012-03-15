Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965357Ab2COVlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:41:18 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:23158
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032342Ab2COVlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:41:10 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202hzz8275dhz2dh87h2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPV:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 15 Mar 2012 17:41:04 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <acme@ghostprotocols.net>
Subject: [perf] exporting perf_pmu_register?
Message-ID: <alpine.DEB.2.00.1203151737430.15513@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm attempting to write a perf pmu driver as a kernel module, but
am finding this difficult to do it properly because
   perf_pmu_register
is not exported.

Would a patch similar to
  https://lkml.org/lkml/2010/8/18/64
be accepted that exported this?

I'm trying to write a RAPL/energy pmu module on a Sandybridge-EP machine
but the sysadmin won't install a custom kernel so I'm stuck trying to do 
it entirely via loadable module, and it turns out this doesn't seem to be 
possible at all :(

Vince
vweaver1@eecs.utk.edu

