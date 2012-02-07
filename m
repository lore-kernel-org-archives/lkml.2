Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2BGUSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:18:07 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37268 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2BGUSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:18:05 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.15.19
Date: Tue, 7 Feb 2012 12:17:51 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 0/3][RFC] tracing/rcu: Add _rcuidle() tracepoint to
 handle rcu_idle_exit() tracepoints
Message-ID: <20120207201750.GA10986@leaf>
References: <20120207145653.829892056@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207145653.829892056@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 09:56:53AM -0500, Steven Rostedt wrote:
> This is an RFC patch set for what I plan on pushing out to handle
> the tracepoints that are called from within rcu_idle_exit() sections.
> 
> The first patch is the tracepoint infrastructure,
> the second is the changes in x86
> the third is the changes in the cpuidle driver.

Patches 2 and 3 look sensible to me as well.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
