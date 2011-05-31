Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1EaONY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:13:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60057 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1EaONX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:13:23 -0400
Date: Tue, 31 May 2011 16:13:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ben Blum <bblum@andrew.cmu.edu>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf cgroup per-task attaching
Message-ID: <20110531141312.GB13134@aftab>
References: <20110531140359.GA13134@aftab>
 <1306850860.2353.111.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306850860.2353.111.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 10:07:40AM -0400, Peter Zijlstra wrote:
> On Tue, 2011-05-31 at 16:03 +0200, Borislav Petkov wrote:
> > Just FYI:
> > 
> > I'm getting
> > 
> > kernel/events/core.c:7445: warning: initialization from incompatible pointer type
> > 
> > when building -rc1 with CONFIG_CGROUP_PERF enabled. AFAICT, this is
> > due to the fact that f780bdb7c1c73009cb57adcf99ef50027d80bf3c dropped
> > the threadgroup arg from cgroup_subsys->attach in favour of per-thread
> > callbacks.
> > 
> > perf_cgroup_attach() actually does reschedule the task context after
> > the cgroup changes so the perf cgroup code would need some non-trivial
> > adjusting to the new APIs.
> 
> lkml.kernel.org/r/tip-74c355fbdfedd3820046dba4f537876cea54c207@git.kernel.org

Hehe, that happened today already! :)

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
