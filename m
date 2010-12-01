Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0LAOIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:08:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46098 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0LAOIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:08:22 -0500
Date: Wed, 1 Dec 2010 15:08:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
Message-ID: <20101201140818.GB7218@basil.fritz.box>
References: <1290340877.2245.124.camel@localhost>
 <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
 <AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
 <AANLkTimN6_v6VibsNU70kV_QUnF4Fj0=M=Akp8aASE-3@mail.gmail.com>
 <1290770652.2145.128.camel@laptop>
 <AANLkTika3r2=gCh4nX-raRU3BoFpWMUEapn3w2bgyGAd@mail.gmail.com>
 <1290771419.2145.137.camel@laptop>
 <1291174123.2405.228.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291174123.2405.228.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How about a new sub-command for node-wide events statistics?
> 
> perf node -n <node> -e <event>?

Seems like the best option to me (and not allowing the uncore events
for the other commands)

But I  don't like "node" because in a non NUMA kernel you won't have nodes, 
but this is still useful. Or with NUMA emulation you may have nodes
that doesn't match the sockets.

Maybe perf package or perf socket ? 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
