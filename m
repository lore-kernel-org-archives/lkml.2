Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1B0XQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:16:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab1B0XQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:16:27 -0500
Date: Sun, 27 Feb 2011 18:16:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Justin TerAvest <teravest@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Chad Talbott <ctalbott@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6 v5.1] cfq-iosched: Introduce CFQ group hierarchical
 scheduling and "use_hierarchy" interface
Message-ID: <20110227231618.GA1014@redhat.com>
References: <4D61FE91.60705@cn.fujitsu.com>
 <4D6201A3.70301@cn.fujitsu.com>
 <4D64788F.6040408@cn.fujitsu.com>
 <20110224181140.GE18494@redhat.com>
 <4D670C14.9040504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D670C14.9040504@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 09:55:32AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Wed, Feb 23, 2011 at 11:01:35AM +0800, Gui Jianfeng wrote:
> >> Hi
> >>
> >> I rebase this series on top of *for-next* branch, it will make merging life easier.
> >>
> >> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
> >> in the way that it puts all CFQ queues in a hidden group and schedules with other 
> >> CFQ group under their parent. The patchset is available here,
> >> http://lkml.org/lkml/2010/8/30/30
> > 
> > Gui,
> > 
> > I was running some tests (iostest) with these patches and my system crashed
> > after a while.
> > 
> > To be precise I was running "brrmmap" test of iostest.
> 
> Vivek,
> 
> I simply run iostest with brrmmap mode, I can't reproduce this bug.
> Would you give more details.
> Can you tell me the iostest command line options?

iostest /dev/dm-1 -G --nrgrp 4 -m 8 --cgtime --io_serviced --dequeue --total

I was actually trying to run all the workloads defined but after running
2 workloads it crashed on 3rd workload.

Now I tried to re-run brrmmap and it did not crash. So I am trying to run
all the inbuilt workloads again.

> Did you enable use_hierarchy in root group?

No I did not. Trying to test the flat setup first.

Thanks
Vivek
