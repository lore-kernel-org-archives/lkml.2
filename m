Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0LALhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:37:52 -0500
Received: from fep19.mx.upcmail.net ([62.179.121.39]:41456 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0LALhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:37:50 -0500
X-SourceIP: 80.56.199.130
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1291174123.2405.228.camel@minggr.sh.intel.com>
References: <1290340877.2245.124.camel@localhost>
	 <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
	 <AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
	 <AANLkTimN6_v6VibsNU70kV_QUnF4Fj0=M=Akp8aASE-3@mail.gmail.com>
	 <1290770652.2145.128.camel@laptop>
	 <AANLkTika3r2=gCh4nX-raRU3BoFpWMUEapn3w2bgyGAd@mail.gmail.com>
	 <1290771419.2145.137.camel@laptop>
	 <1291174123.2405.228.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 12:37:45 +0100
Message-ID: <1291203465.4023.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=Nww7yNiXF4C1XGF+VcigPkOcTpD8wJaI1KQuZlH5eEk= c=1 sm=0 a=0HiPQv_fK0EA:10 a=IkcTkHD0fZMA:10 a=0suhqzWKANHML3nlnnUA:9 a=Cl6gLah7alAz0prUR7Cmjj-OznkA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 11:28 +0800, Lin Ming wrote:

> How about a new sub-command for node-wide events statistics?
> 
> perf node -n <node> -e <event>?

Maybe as a very slim wrapper around perf stat, but personally I wouldn't
care.


