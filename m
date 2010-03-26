Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0CZLWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 07:22:32 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42923 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0CZLWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 07:22:30 -0400
Date: Fri, 26 Mar 2010 12:22:27 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: set_cpus_allowed_ptr
In-Reply-To: <1269597796.12097.133.camel@laptop>
Message-ID: <Pine.LNX.4.64.1003261218410.27328@ask.diku.dk>
References: <1269597796.12097.133.camel@laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010, Peter Zijlstra wrote:

> Hi,
> 
> Would it make sense to clean up the set_cpus_allowed() vs
> set_cpus_allowed_ptr() mess using the semantic patch tool?
> 
> I guess it would be three patches:
>  1) converting the current remaining set_cpus_allowed() users into
>     set_cpus_allowed_ptr().
>  2) remove set_cpus_allowed().
>  3) rename set_cpus_allowed_ptr() to set_cpus_allowed()

Perhaps a subtlety is that set_cpus_allowed is creating a new variable, 
whose address it sends to set_cpus_allowed_ptr?

julia
