Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2JFBHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 21:07:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:34030 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2JFBHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 21:07:04 -0400
Date: Fri, 5 Oct 2012 18:06:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Minimal jitter = good desktop.
In-Reply-To: <op.wlqe9kw36426ze@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1210051803180.13407@asgard.lang.hm>
References: <op.wlqe9kw36426ze@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

less jitter != less latency

you could (in theory) eliminate jitter by delaying every keypress 
processed for exactly 1 second by having the code paths that process 
keypresses faster insert delays before implementing the results.

that would result in zero jitter, but horrific latency.

latency is how long it takes to do something, jitter is how much the 
latency varies.

normally, if you optimize for one you make the other worse.

If you optimize for latency, you try to finish everything as soon as you 
can. Since some things take longer than others, jitter increases.

David Lang

On Sat, 6 Oct 2012, Uwaysi Bin Kareem wrote:

> Reducing jitter seems central for many things.
> First of all keypresses seem faster. (less jitter = less latency).
> Doom 3 and similar jittersensitive OpenGL applications run smoothly, and 
> better than windows. Doom 3 was also my main app to get running well, and 
> measuring jitter in the signalpath of OpenGL improved the overall computing 
> experience.
>
> Even youtube videos who are not synced to refresh, with a refresh of 60, and 
> a videofps of 30, runs quite well. 
> http://paradoxuncreated.com/Blog/wordpress/?p=3221
>
> System is responsive, and I have only had one problem, and that is packing 
> seems not to work at the moment.
>
> For a fast test in Ubuntu, try 
> http://paradoxuncreated.com/Blog/wordpress/?p=2268
>
> Definately a recommended config on the desktop.
>
> Peace Be With You.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
