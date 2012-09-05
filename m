Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab2IERBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:01:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57774 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2IERBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:01:44 -0400
Message-ID: <1346864493.2600.27.camel@twins>
Subject: Re: [tip:sched/core] sched: Fix load avg vs cpu-hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: paulmck@linux.vnet.ibm.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Wed, 05 Sep 2012 19:01:33 +0200
In-Reply-To: <20120905132939.GA3480@gmail.com>
References: <1345454817.23018.27.camel@twins>
	 <tip-f319da0c6894fcf55e21320e40506418a2aad629@git.kernel.org>
	 <1346848616.2600.26.camel@twins> <20120905132939.GA3480@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 15:29 +0200, Ingo Molnar wrote:
> > Oh argh.. this patch isn't actually right.. I actually removed 
> > it from my series but forgot to update the tarball.
> 
> Sigh.

Yeah, sorry about that, jet-lag makes me do stupid at a higher rate than
usual :/

> > Ingo can you still make it go away or should I do a delta?
> 
> Please do a delta. 

Ok, will do.
