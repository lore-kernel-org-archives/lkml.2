Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0FYJIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:08:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47550 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0FYJIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:08:07 -0400
Date: Fri, 25 Jun 2010 11:08:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H.Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100625090759.GA13421@basil.fritz.box>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
 <1277361352.1875.838.camel@laptop>
 <1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 10:12:43AM +0800, Huang Ying wrote:
> On Thu, 2010-06-24 at 14:35 +0800, Peter Zijlstra wrote:
> > Something like this, but filled out with some arch code that does the
> > self-ipi and calls irq_work_run() should do.
> > 
> > No need to molest the softirq code, no need for limited vectors of any
> > kind.
> 
> Now, as far as my understanding goes, hard IRQ based solution is
> acceptable for everyone.
> 
> Ingo and Andi,
> 
> Do you agree?

Yes that's fine for me. The error handling issues can be solved in other
ways too.

-Andi
