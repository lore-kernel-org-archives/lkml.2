Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2JFRek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:34:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46076 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2JFReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:34:36 -0400
Date: Sat, 6 Oct 2012 19:34:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, jolsa@redhat.com,
        eranian@google.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Re: Tie lose "perf, tools" ends in Haswell PMU patchkit
Message-ID: <20121006173429.GR16230@one.firstfloor.org>
References: <1349299363-30714-1-git-send-email-andi@firstfloor.org> <507046D0.8090408@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507046D0.8090408@computer.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 04:57:20PM +0200, Jan Ceuleers wrote:
> On 10/03/2012 11:22 PM, Andi Kleen wrote:
> > This fixes some left over issues in my Haswell PMU patchkit yesterday:
> > Ideally applied on top, although there should be no direct dependencies.
> > 
> > - Now the kernel supplied sysfs aliases can be directly used for cpu.
> > This means I can use "tx-aborts" instead of "cpu/tx-aborts/
> > - List the kernel events
> > - Support using the same names as generic events for kernel events.
> > This allows to use cpu/instructions,intx=1/ which was not possible
> > before because instructions clashed with the generic name.
> 
> I (i.e. me, moi) received only patches 2/3 and 3/3. Is there a patch 1/3?

Yes there was. Not sure what happened. But these three patches had some bugs,
I'll post an updated version folded into the original Haswell patchkit
after the merge window closes. Right now people seem to be too busy
to review it.  

Let me know if you want to test something earlier.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
