Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0CQHd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 03:33:57 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51506 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab0CQHd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 03:33:56 -0400
Message-ID: <4BA085DE.40604@dcl.info.waseda.ac.jp>
Date: Wed, 17 Mar 2010 16:33:50 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
 lock
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100317014755.GC5258@nowhere>
In-Reply-To: <20100317014755.GC5258@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/10 10:47, Frederic Weisbecker wrote:
 > On Sun, Mar 14, 2010 at 07:38:37PM +0900, Hitoshi Mitake wrote:
 >> I implemented it on the branch perf/inject of Frederic's 
random-tracing tree.
 >> Because the branch is hottest place of lock and tracing :)
 >
 >
 > Ouch! You shouldn't do this. The patches inside were
 > trials submitted for review and the resulting discussion
 > concluded that the injection must be redesigned.

Oh, sorry...
And I'd like to look at redesigning way of inject.

 >
 > More generally I don't recommend you to base your patches
 > on my tree. I use it as a buffer when I send patches
 > for review or for pull requests.
 >
 > The branches inside can be randomly rebased (unless a
 > branch is waiting to be pulled) and they are pretty async
 > with the -tip tree.
 >
 > The hottest and most sync tree on which you should base your patches
 > for perf is:
 >
 > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
 > 	perf/core
 >
 > With that you have best chances to work on a sane and up-to-date
 > base.
 >
 > Thanks.
 >
 >

I'll work on tip/perf/core from next time :)

Thanks,
	Hitoshi
