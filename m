Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1GDIjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:39:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34552 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1GDIjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:39:06 -0400
Subject: Re: [PATCH 1/4] perf, x86: Add Intel Nehalem/Westmere uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309761541.18875.40.camel@minggr.sh.intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <1309421396-17438-2-git-send-email-ming.m.lin@intel.com>
	 <20110630165849.GE23059@one.firstfloor.org>
	 <1309761541.18875.40.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 04 Jul 2011 10:38:50 +0200
Message-ID: <1309768730.3282.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 14:39 +0800, Lin Ming wrote:
> > Does this really need to be a raw spinlock? 
> 
> I think spinlock is enough. 

No, raw_spinlock_t was correct.

Talking of which:

+       struct spinlock lock;

That too should be a raw_spinlock_t.
