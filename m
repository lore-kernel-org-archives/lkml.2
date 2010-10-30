Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0J3Buz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 21:50:55 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42460 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368Ab0J3Buy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 21:50:54 -0400
Date: Fri, 29 Oct 2010 20:50:50 -0500
From: Russ Anderson <rja@sgi.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, rja@americas.sgi.com
Subject: Re: [BUG] intr_remap: Simplify the code further
Message-ID: <20101030015050.GA9557@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20101029222227.GJ32456@sgi.com> <1288399062.2690.169.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288399062.2690.169.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 05:37:42PM -0700, Suresh Siddha wrote:
> On Fri, 2010-10-29 at 15:22 -0700, Russ Anderson wrote:
> > There is a regression that is causing a NULL pointer dereference
> > in free_irte when shutting down xpc.  git bisect narrowed it down
> > to git commit d585d060b42bd36f6f0b23ff327d3b91f80c7139, which 
> > changed free_irte().  Reverse applying the patch fixes the problem.
> > 
> 
> Russ, Is this with !CONFIG_SPARSE_IRQ?


CONFIG_SPARSE_IRQ=y


-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
