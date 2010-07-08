Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0GHEkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:40:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54231 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0GHEkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ROhet6LskwCnWbN+FcXrAdtJZw9JUM6QUHMglrnn4CJKtwUZ8RLzoDK330VJV8795K
         CJfr8FI8LfqSdEu/CRN9cTTGwbwn8GT/pIqPot82ShGzDoJkUy3jkB0VYl8t0pn6kMm/
         325+7P1yvIlfAcjJPooXZj0EFQ2CBwkqIr6jg=
Date: Thu, 8 Jul 2010 06:40:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       "2 . 6 . 31 . x-2 . 6 . 34 . x" <stable@kernel.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20100708044023.GB7564@nowhere>
References: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 06:36:49AM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
> 
> This resurrects flat and graph (absolute fractals) callchains.
> All tested with and without newt.
> 
> As you know there are still things to fix: filtering by parents (probably a
> regression) and dso multiple callchains (not a regression).
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       perf: Resurrect flat callchains
>       perf: Sync callchains with period based hits



BTW, the second is not that small for a regression fix. If that's a problem,
tell me and I will move this one to perf/core.

