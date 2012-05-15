Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965247Ab2EOPbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:31:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33145 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533Ab2EOPbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:31:41 -0400
Date: Tue, 15 May 2012 08:31:36 -0700
From: Tejun Heo <tj@kernel.org>
To: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: fix oops in processing workqueue
Message-ID: <20120515153136.GF6119@google.com>
References: <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
 <1336516260.8226.61.camel@twins>
 <alpine.LSU.2.00.1205081553250.4497@eggly.anvils>
 <20120509092536.GC8585@gmail.com>
 <alpine.LSU.2.00.1205091219590.20881@eggly.anvils>
 <alpine.LSU.2.00.1205101049460.17714@eggly.anvils>
 <20120514212753.GM2366@google.com>
 <1337080288.27694.38.camel@twins>
 <20120515151048.GA6119@google.com>
 <20120515152952.GA27838@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515152952.GA27838@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 11:29:52AM -0400, Dave Jones wrote:
> On Tue, May 15, 2012 at 08:10:48AM -0700, Tejun Heo wrote:
>  > >From 4d82a1debbffec129cc387aafa8f40b7bbab3297 Mon Sep 17 00:00:00 2001
>  > From: Peter Zijlstra <peterz@infradead.org>
>  > Date: Tue, 15 May 2012 08:06:19 -0700
>  > 
>  > Under memory load, on x86_64, with lockdep enabled, the workqueue's
>  > process_one_work() has been seen to oops in __lock_acquire(), barfing
>  > on a 0xffffffff00000000 pointer in the lockdep_map's class_cache[].
> 
> can you elaborate what 'memory load' means here ?
> I'm curious if I can add something to my fuzzing tool to shake out bugs like this.

I think Hugh knows and can explain this much better than I do.  Hugh?

Thanks.

-- 
tejun
