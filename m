Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0IMUJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:09:02 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35412 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab0IMUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VCjIS87Je/Q4veMiNPi2p15JzJGQQ+JfOFnJaZZtLRCYHaXLGjpLKwX03v+HDtZZgh
         +6V4hU94QXbPkgAU7nxHBSzkAhfAObczpLRMMss3zMhd3o9AywxCKcVj0qPYzMetoL9D
         bfgRmoNgVEqPuv76bE5K+iChGY79pgeDRGYQY=
Date: Mon, 13 Sep 2010 22:08:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Prasad <prasad@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] perf_events and hw_breakpoints fix and cleanup
Message-ID: <20100913200852.GC6155@nowhere>
References: <1284408080-2135-1-git-send-email-matthltc@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284408080-2135-1-git-send-email-matthltc@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 01:01:17PM -0700, Matt Helsley wrote:
> Fixes a bug in the way that hardward breakpoints pass around [v]pids.
> 
> The last two patches move the pid resolution closer to the syscall
> and avoid passing pids entirely so that the perf event code does not
> need to worry about being in the wrong pid namespace when kernel
> counters are created.
> 
> NOTE: Applies to -tip perf/core. Compile-tested only at the moment.



Thanks a lot, I'll test that and push for -tip + backport in no big problem
arise.

