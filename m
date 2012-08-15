Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2HOOpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:45:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54721 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2HOOpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:45:08 -0400
Message-ID: <1345041897.31459.95.camel@twins>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        vincent.guittot@linaro.org, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Date: Wed, 15 Aug 2012 16:44:57 +0200
In-Reply-To: <502BB000.60502@linux.intel.com>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
	 <502BB000.60502@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 07:19 -0700, Arjan van de Ven wrote:
> Ideally the scheduler builds up some history of the typical run
> duration of the task (with a bias to more recent runs).
> But... even then, the past is only a poor predictor for the future. 

PJTs patches do this. But yes, a crystal-ball instruction which
completes in a single cycle would be most appreciated :-)
