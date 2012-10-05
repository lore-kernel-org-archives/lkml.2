Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2JEUAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:00:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2JEUAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:00:37 -0400
Date: Fri, 5 Oct 2012 16:00:30 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: RCU_USER_QS traces.
Message-ID: <20121005200030.GA1615@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20121004144106.GB11191@redhat.com>
 <20121005123609.GA13172@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005123609.GA13172@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 02:36:19PM +0200, Frederic Weisbecker wrote:
 > On Thu, Oct 04, 2012 at 10:41:06AM -0400, Dave Jones wrote:
 > >  > We have CONFIG_RCU_USER_QS that is a specific case. It's an intermediate state
 > >  > before we implement a true CONFIG_NO_HZ_FULL. But the option is useless on its
 > >  > own for users. Worse, it introduces a real overhead. OTOH we want it to be upstream
 > >  > to make the development of full tickless feature more incremental.
 > > 
 > > I couldn't resist trying it.. Did these get reported yet ?
 > 
 > Hi Dave,
 > 
 > Thanks for this report. I need to find the source of the issue.
 > 
 > If you don't mind, could you please apply the following patch? You'll also
 > need to enable:
 > 
 > - CONFIG_EVENT_TRACING and CONFIG_RCU_TRACE
 > 
 > And you also need this boot parameter:
 > 
 > - trace_event=rcu_dyntick
 > 
 > Thanks a lot!

Hrmph, it seems to have gone into hiding. I can't reproduce it any more.
If it shows about again, I'll get back to you.

	Dave 
