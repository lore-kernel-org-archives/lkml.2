Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1EPJES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:04:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35838 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab1EPJER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:04:17 -0400
Date: Mon, 16 May 2011 11:03:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, tglx@linutronix.de,
        hpa@zytor.com, steiner@sgi.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] x84_64, apic: Use probe routines to simplify apic
 selection
Message-ID: <20110516090355.GA12325@elte.hu>
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
 <20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com>
 <20110516080844.GC27635@elte.hu>
 <BANLkTimAYf1BBAqDpVbc9jRWtfHcg2SbNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimAYf1BBAqDpVbc9jRWtfHcg2SbNQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

>   Yes, this should be a cleaner step but it requires some more code churn 
> that is why I think Suresh' approach is pretty well done! Ingo, probably we 
> could do so on *top* of this changes as only time permits? The problem is 
> that I personally can't guarantee I continue working on the task this week, 
> if Suresh is able to -- this would be great, if not -- probably even such 
> minimal disturbing patch worth merging, it definitley makes code better I 
> think ;)

We can do it on top, but within the series please. The APIC mess is not 
improving so we only want to merge features that are done cleanly.

Thanks,

	Ingo
