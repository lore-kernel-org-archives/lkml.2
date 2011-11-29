Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1K2JsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:48:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35102 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1K2JsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:48:12 -0500
Message-ID: <1322560075.2921.194.camel@twins>
Subject: Re: [patch 1/6] sched, nohz: introduce nohz_flags in the struct rq
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Tue, 29 Nov 2011 10:47:55 +0100
In-Reply-To: <1322524749.21329.70.camel@sbsiddha-desk.sc.intel.com>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.882444396@sbsiddha-desk.sc.intel.com>
	 <1322130279.2921.7.camel@twins>
	 <1322524749.21329.70.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 15:59 -0800, Suresh Siddha wrote:
> I will include this info in the next update.

That was slightly more than I'd expected, but great, thanks!

Always try to answer the: What and Why of patches, the how etc. is
mostly clear from the patch itself. I know its hard, I often write
crappy changelogs myself (and often kick myself for having written
crappy changelogs), so I'm trying to improve the situation by pestering
other people ;-)
