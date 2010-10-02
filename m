Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0JBLBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 07:01:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:35601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0JBLBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 07:01:17 -0400
Subject: Re: [RESEND PATCH 1/2] IRQ: use cpu_possible_mask rather than
 online_mask in setup_affinity
From: Peter Zijlstra <peterz@infradead.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: miltonm@bga.com, Thomas Gleixner <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
References: <1285968378-12805-1-git-send-email-nacc@us.ibm.com>
	 <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Oct 2010 13:01:02 +0200
Message-ID: <1286017262.2144.90.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 14:26 -0700, Nishanth Aravamudan wrote:
> The use of online_mask requires architecture code to be hotplug-aware to
> account for IRQ round-robin'ing. 

Architectures that support hotplug should be hotplug aware, that's not
too much to ask imho.

> With user-driven dynamic SMT,

What's that?

