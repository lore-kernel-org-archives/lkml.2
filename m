Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1CYJdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:33:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab1CYJdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:33:35 -0400
Subject: Re: [PATCH 1/2] WARN_ON_SMP(): Allow use in if statements on UP
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <20110317192208.444147791@goodmis.org>
References: <20110317192105.308382309@goodmis.org>
	 <20110317192208.444147791@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 10:35:38 +0100
Message-ID: <1301045738.2250.153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 15:21 -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Both WARN_ON() and WARN_ON_SMP() should be able to be used in
> an if statement.
> 
>         if (WARN_ON_SMP(foo)) { ... }
> 
> Because WARN_ON_SMP() is defined as a do { } while (0) on UP,
> it can not be used this way.
> 
> Convert it to the same form that WARN_ON() is, even when
> CONFIG_SMP is off.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org> 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


