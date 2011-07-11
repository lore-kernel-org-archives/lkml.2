Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1GKNFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:05:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1GKNFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:05:23 -0400
Date: Mon, 11 Jul 2011 09:05:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 0/3]CFQ: add think time check for service tree and group
Message-ID: <20110711130520.GA30674@redhat.com>
References: <1309757789.15392.236.camel@sli10-conroe>
 <CANejiEXryM=hawNjQZPYEM2L97+gUYqHQ_YQJ5p5gLTvBkC25Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANejiEXryM=hawNjQZPYEM2L97+gUYqHQ_YQJ5p5gLTvBkC25Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 01:44:05PM +0800, Shaohua Li wrote:
> 2011/7/4 Shaohua Li <shaohua.li@intel.com>:
> > Hi,
> >  Currently when the last queue of a service tree/group is empty, CFQ
> > doesn't expire the queue. This is to allow requests from the tree/group
> > come soon, so tree/group doesn't miss its share. But if the think time
> > is big, the assumption isn't correct. idling the queue is just wasting
> > bandwidth.
> >
> > Originally I was hoping this can resolve Vivek's fsync issue, but it
> > doesn't. The fsync issue is caused by queue idling. But since think time
> > check only helps for think time above default queue idle time (8ms),
> > think time check doesn't help.
> >
> > On the other hand, think time check is still helpful for queues with
> > think time. I had test case in follow patches show throughput
> > improvement without sacrifice tree/group shares.
> >
> Jens,
> can you look at the patches? I refreshed some patches in replying
> Vivek, I can resend if required.

Yep, please resend. That would be easier.

Thanks
Vivek
