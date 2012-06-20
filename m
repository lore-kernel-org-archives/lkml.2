Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2FTKRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:17:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:56096 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2FTKRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:17:48 -0400
Message-ID: <1340187450.21745.96.camel@twins>
Subject: Re: [PATCH] sched/cpu hotplug: Don't traverse sched domain tree of
 cpus going offline
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mingo@kernel.org, pjt@google.com, suresh.b.siddha@intel.com,
        seto.hidetoshi@jp.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de,
        dhillf@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 12:17:30 +0200
In-Reply-To: <4FE19CF5.3060000@linux.vnet.ibm.com>
References: <20120602185721.5559.65562.stgit@srivatsabhat>
	 <4FE19CF5.3060000@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 15:20 +0530, Srivatsa S. Bhat wrote:
> Any thoughts on this patch?
> 
Yeah, I stared at it for a while and got a head-ache.. the idle-balance
part if ok, the rt.c part needs a little more-thinking.

Thanks for reminding me.. I'll try and have another look.
