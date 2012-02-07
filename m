Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2BGUtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:49:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41843 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab2BGUts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:49:48 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VojHJqWupt0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=Y73zmO_17t84VO1Fj6QA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328647785.2200.112.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3][RFC] cpuidle/tracing: Denote the tracepoints as
 being in rcu_idle_exit() section
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Len Brown <len.brown@intel.com>
Date: Tue, 07 Feb 2012 15:49:45 -0500
In-Reply-To: <20120207154009.GR5941@linux.vnet.ibm.com>
References: <20120207145653.829892056@goodmis.org>
	 <20120207151049.632303467@goodmis.org>
	 <20120207154009.GR5941@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 07:40 -0800, Paul E. McKenney wrote:
> On Tue, Feb 07, 2012 at 09:56:56AM -0500, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > As the tracepoints in the cpuidle code are called when rcu_idle_exit() is in
> > effect, the _rcuidle() version must be used, otherwise the rcu_read_lock()s
> > that protect the tracepoint will not be honored.
> > 
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Looks good to me!
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks, but does this include patch 2/3 as well?

-- Steve


