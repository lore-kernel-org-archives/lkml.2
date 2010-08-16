Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0HPIsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:48:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0HPIsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:48:50 -0400
Subject: Re: [PATCH/RFC 3/5] [PATCH] sched: add book scheduling domain
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <1281734572.2704.39.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20100812172544.655648128@de.ibm.com>
	 <20100812172623.140578409@de.ibm.com>
	 <1281734572.2704.39.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 10:48:37 +0200
Message-ID: <1281948517.1926.1049.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 14:22 -0700, Suresh Siddha wrote:
> On Thu, 2010-08-12 at 10:25 -0700, Heiko Carstens wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > On top of the SMT and MC scheduling domains this adds the BOOK scheduling
> > domain. This is useful for machines that have a four level cache hierarchy
> > and but do not fall into the NUMA category.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> PeterZ had some ideas in cleaning up the sched domain setup to avoid
> this maze of #ifdef's. I will let him comment on this.

http://lkml.org/lkml/2009/8/18/169

More information in this thread: http://lkml.org/lkml/2009/8/20/190


