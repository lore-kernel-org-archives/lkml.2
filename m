Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3AGR6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:58:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45752 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab3AGR6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:58:45 -0500
Date: Mon, 7 Jan 2013 09:58:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad.Ben-Yossef.gilad@benyossef.com
Subject: Re: [PATCH rcu] Remove unused code originally used for context
 tracking
Message-ID: <20130107175833.GN2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
 <1354179992.2499.35.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hysBreTXE-rXVQ5no+3B8hZ-3XMgap20PAP9u76-j-Tgg@mail.gmail.com>
 <20121129113627.GS2474@linux.vnet.ibm.com>
 <1354256362.2552.6.camel@ThinkPad-T5421.cn.ibm.com>
 <20130107173906.GL2525@linux.vnet.ibm.com>
 <CAFTL4hx7Z6WPWnhQVY=ea31kfi1yp8b_Jm-L-kNLUDani7fCbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hx7Z6WPWnhQVY=ea31kfi1yp8b_Jm-L-kNLUDani7fCbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010717-5806-0000-0000-00001DE6E16B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 06:46:07PM +0100, Frederic Weisbecker wrote:
> 2013/1/7 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Fri, Nov 30, 2012 at 02:19:22PM +0800, Li Zhong wrote:
> >> As new context tracking subsystem added, it seems ignore_user_qs and
> >> in_user defined in struct rcu_dynticks are no longer needed, so remove
> >> them.
> >>
> >> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> >
> > Hearing no objections from  Frederic, I have queued this patch for 3.9
> 
> Thanks Paul!
> 
> And feel free to add my ack.

Done, thank you!

							Thanx, Paul

