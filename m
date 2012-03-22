Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2CVHuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:50:21 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63771 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2CVHuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:50:18 -0400
Date: Thu, 22 Mar 2012 08:50:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Michael J. Wang" <mjwang@broadcom.com>,
        Yong Zhang <yong.zhang0@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/1] scheduler: minor improvement to
 pick_next_highest_task_rt in linux-3.3
Message-ID: <20120322075013.GB31810@gmail.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83D6B@IRVEXCHMB08.corp.ad.broadcom.com>
 <20120321014050.GA19766@zhy>
 <2EF88150C0EF2C43A218742ED384C1BC0FC84327@IRVEXCHMB08.corp.ad.broadcom.com>
 <20120321021229.GB19766@zhy>
 <2EF88150C0EF2C43A218742ED384C1BC0FC8438B@IRVEXCHMB08.corp.ad.broadcom.com>
 <1332320819.18960.468.camel@twins>
 <2EF88150C0EF2C43A218742ED384C1BC0FC85433@IRVEXCHMB08.corp.ad.broadcom.com>
 <1332358552.18960.501.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332358552.18960.501.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2012-03-21 at 18:33 +0000, Michael J. Wang wrote:
> > 
> > OK.  Thanks.  I was afraid the details were too verbose when the fix
> > was obvious to the experts.  Anyways, I now know the format you
> > are expecting, so I will do better next time. 
> 
> Since you took the trouble to write it, I thought it worth the trouble
> to include.
> 
> Very often Changelogs are way too spartan (my own included), I can't
> recall the amount of times I've kicked myself for leaving out some - at
> the time - obvious details.
> 
> So I prefer people to go overboard a bit and err on the side 
> of too much information :-)

Yeah. Current trends are: for every 1000 patches sent there's 
maybe one patch that has a tad too much information in its 
changelog - but instead offers good entertainment in the 
changelog so it's still perfectly fine. 990 patches have too 
little information. The remaining 9 are just fine.

Thanks,

	Ingo
