Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1CYVvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:51:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1CYVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:51:31 -0400
Subject: Re: [RFC][PATCH 00/14] Rewrite sched_domain/sched_group creation
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
In-Reply-To: <1301089601.2250.314.camel@laptop>
References: <20110314150613.749843433@chello.nl>
	 <1301089601.2250.314.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 22:53:35 +0100
Message-ID: <1301090015.2250.315.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 22:46 +0100, Peter Zijlstra wrote:
> > Anyway, not quite there yet.. patches build and boot on a 2*6*2 wsm
> box.
> 
> Still boots, although a 2 node system isn't very interesting.
> 
OK, halt made the domain stuff explode (also didn't test hotplug), so
there's something fishy.

