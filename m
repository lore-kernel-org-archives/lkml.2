Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0DBXJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 19:09:40 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:38233 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755317Ab0DBXJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 19:09:34 -0400
Date: Sat, 3 Apr 2010 10:09:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Janos Haar <janos.haar@netcenter.hu>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       xfs@oss.sgi.com, axboe@kernel.dk
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
 please!...)
Message-ID: <20100402230905.GW3335@dastard>
References: <03ca01cacb92$195adf50$0400a8c0@dcccs>
 <2375c9f91003242029p1efbbea1v8e313e460b118f14@mail.gmail.com>
 <20100325153110.6be9a3df.kamezawa.hiroyu@jp.fujitsu.com>
 <02c101cacbf8$d21d1650$0400a8c0@dcccs>
 <179901cad182$5f87f620$0400a8c0@dcccs>
 <t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
 <1fe901cad2b0$d39d0300$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fe901cad2b0$d39d0300$0400a8c0@dcccs>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 03, 2010 at 12:07:00AM +0200, Janos Haar wrote:
> Hello,
> 
> ----- Original Message ----- From: "Américo Wang"
> <xiyou.wangcong@gmail.com>
> To: "Janos Haar" <janos.haar@netcenter.hu>
> Cc: <linux-kernel@vger.kernel.org>; "KAMEZAWA Hiroyuki"
> <kamezawa.hiroyu@jp.fujitsu.com>; <linux-mm@kvack.org>;
> <xfs@oss.sgi.com>; "Jens Axboe" <axboe@kernel.dk>
> Sent: Thursday, April 01, 2010 12:37 PM
> Subject: Re: Somebody take a look please! (some kind of kernel bug?)
> 
> 
> >On Thu, Apr 1, 2010 at 6:01 PM, Janos Haar
> ><janos.haar@netcenter.hu> wrote:
> >>Hello,
> >>
> >
> >Hi,
> >This is a totally different bug from the previous one reported by you. :)
> 
> Today i have got this again, exactly the same. (if somebody wants
> the log, just ask)
> There is a cut:

Small hint - please put the subsytemthe bug occurred in in the
subject line. I missed this in the firehose of lkml traffic because
there wasnothing to indicate to me it was in XFS. Soemthing like:

"Kernel crash in xfs_iflush_cluster"

Won't get missed quite so easily....

This may be a fixed problem - what kernel are you running?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
