Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0HPIaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:30:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:52543 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0HPIaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:30:07 -0400
Subject: Re: [PATCH/RFC 2/5] [PATCH] sched: pass sched_domain_level to
 sched_power_savings_store
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20100812172622.349333778@de.ibm.com>
References: <20100812172544.655648128@de.ibm.com>
	 <20100812172622.349333778@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 10:29:57 +0200
Message-ID: <1281947397.1926.1012.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 19:25 +0200, Heiko Carstens wrote:
> Pass the corresponding sched domain level to sched_power_savings_store instead
> of a yes/no flag which indicates if the level is SMT or MC.
> This is needed to easily extend the function so it can be used for a third
> level. 

Ah, so the plan is to reduce the number of knobs, not create more.

Sysadmins really aren't interested in having a powersavings knob per
topology level.

