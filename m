Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab1KRP0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:26:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:49307 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752275Ab1KRP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:26:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18GBdtNA3MGOd/7zPDaFg+nzC06LoBN6AjvFL+lP3
	sKzr4kLDvkvkTY
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321629141.2197.4.camel@twins>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321556904.15339.25.camel@sbsiddha-desk.sc.intel.com>
	 <1321629141.2197.4.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:26:10 +0100
Message-ID: <1321629970.7080.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:12 +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-17 at 11:08 -0800, Suresh Siddha wrote:
> > 
> > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > Subject: sched: cleanup domain traversal in select_idle_sibling
> > 
> > Instead of going through the scheduler domain hierarchy multiple times
> > (for giving priority to an idle core over an idle SMT sibling in a busy
> > core), start with the highest scheduler domain with the SD_SHARE_PKG_RESOURCES
> > flag and traverse the domain hierarchy down till we find an idle group.
> > 
> > This cleanup also addresses an issue reported by Mike where the recent
> > changes returned the busy thread even in the presence of an idle SMT
> > sibling in single socket platforms.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Cc: Mike Galbraith <efault@gmx.de> 
> 
> Thanks Suresh!

Tested-by: Mike Galbraith <efault@gmx.de>


