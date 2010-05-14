Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0ENQ20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:28:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:3514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0ENQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:28:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UAp48aZzwHjbk3YgJyEsMyiTGR2WR7MnEmvbUObMKyRUw9DJDvjRuvOeFHaIUhCape
         h14VDePjNp4VSKdbQLWLUe5AzAsSSLpujhGrUUccA4W/L4FRNI7NkXh6Tl3LaCypfnn3
         2fiWvGj6INF+i7Y5UiU6ADZRB7ydOljpIzHk0=
Date: Fri, 14 May 2010 20:28:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
Message-ID: <20100514162813.GB13509@lenovo>
References: <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com> <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com> <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com> <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com> <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com> <1273834571.3530.82.camel@minggr.sh.intel.com> <20100514115655.GA18069@elte.hu> <20100514135240.GA4952@lenovo> <20100514145213.GA13509@lenovo> <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:52:28PM +0530, Jaswinder Singh Rajput wrote:
... 
> Yes, this works for me. Now I am not getting general protection fault.
> 
> It seems hardware events are not supported for P4 yet.
> 
> $ ./perf stat -e
> cycles,instructions,cache-references,cache-misses,branches,branch-misses,bus-cycles
> ls > /dev/null
> 
>  Performance counter stats for 'ls':
> 
>   <not counted>  cycles
>          601636  instructions             #      0.000 IPC    (scaled
> from 91.80%)
>   <not counted>  cache-references
>   <not counted>  cache-misses
>   <not counted>  branches
>   <not counted>  branch-misses
>   <not counted>  bus-cycles
> 
>     0.003364910  seconds time elapsed

Thanks Jaswinder,

it means counters management somehow screwed at moment (it was working before).
I'm working on it.

	-- Cyrill
