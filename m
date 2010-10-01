Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0JASmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:42:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0JASmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:42:12 -0400
Date: Fri, 1 Oct 2010 11:09:23 -0700
From: Greg KH <gregkh@suse.de>
To: tmhikaru@gmail.com
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35,
 2.6.35.1 and later
Message-ID: <20101001180923.GB9353@suse.de>
References: <20101001035321.GA2360@roll>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001035321.GA2360@roll>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:53:21PM -0400, tmhikaru@gmail.com wrote:

<snip>

> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu Apr 22 21:50:19 2010 +0200
> 
>     sched: Cure load average vs NO_HZ woes
> 
>     Chase reported that due to us decrementing calc_load_task prematurely
>     (before the next LOAD_FREQ sample), the load average could be scewed
>     by as much as the number of CPUs in the machine.
> 
>     This patch, based on Chase's patch, cures the problem by keeping the
>     delta of the CPU going into NO_HZ idle separately and folding that in
>     on the next LOAD_FREQ update.
> 
>     This restores the balance and we get strict LOAD_FREQ period samples.
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Acked-by: Chase Douglas <chase.douglas@canonical.com>
>     LKML-Reference: <1271934490.1776.343.camel@laptop>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Care to resend this and cc: Peter, Chase, and Ingo?

thanks,

greg k-h
