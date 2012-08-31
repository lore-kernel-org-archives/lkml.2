Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2HaViy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:38:54 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36815 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab2HaVix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:38:53 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 14:38:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 02/26] rcu: New rcu_user_enter_irq() and
 rcu_user_exit_irq() APIs
Message-ID: <20120831213844.GR4259@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831191321.GQ4259@jtriplet-mobl1>
 <CAFTL4hxsM7LUG5-NVnZsDCM7UpprqSmBXTyUni6GuO9NcwsDeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxsM7LUG5-NVnZsDCM7UpprqSmBXTyUni6GuO9NcwsDeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 09:54:39PM +0200, Frederic Weisbecker wrote:
> 2012/8/31 Josh Triplett <josh@joshtriplett.org>:
> > Given that, the "enter" and "exit" names seem confusing.  This seems
> > more like a flag you can set and clear, rather than a delimited region
> > as suggested by an enter/exit pair.
> >
> > How about something vaguely like rcu_user_irq_set_eqs and
> > rcu_user_irq_clear_eqs?
> 
> I'd rather suggest rcu_user_enter_after_irq and
> rcu_user_exit_after_irq. It describes precisely what it does.

Those names sound reasonable, sure; in the context of "after",
enter/exit sounds less confusing.

- Josh Triplett
