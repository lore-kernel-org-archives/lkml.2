Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0LVIoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:44:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:23932 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab0LVIoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:44:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,212,1291622400"; 
   d="scan'208";a="870794737"
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1293006808.2170.42.camel@laptop>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
	 <1293006808.2170.42.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 16:47:08 +0800
Message-ID: <1293007628.2565.159.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 16:33 +0800, Peter Zijlstra wrote:
> On Wed, 2010-12-22 at 16:12 +0800, Lin Ming wrote:
> > It's applied on top of tip/master(3ea1f4f89) and Andi's offcore
> > patchsets are needed. 
> 
> I still haven't gotten a version of that I'm willing to apply.

OK, then I'll update this patch after the offcore patches applied.


