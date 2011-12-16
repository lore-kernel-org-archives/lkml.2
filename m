Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1LPGOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:14:54 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:39058 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1LPGOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:14:53 -0500
Subject: Re: linux-next: build failure after merge of the target-merge tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <CAO+b5-pyo=kR5JuWbQzMd6X70s4AwSWJV7dq3F9BvwLwTDPm7A@mail.gmail.com>
References: <20111215132902.d0a90a93696702e09b0c60bf@canb.auug.org.au>
	 <CAO+b5-pyo=kR5JuWbQzMd6X70s4AwSWJV7dq3F9BvwLwTDPm7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 22:14:49 -0800
Message-ID: <1324016089.28227.5.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 12:26 +0100, Bart Van Assche wrote:
> On Thu, Dec 15, 2011 at 3:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the target-merge tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > drivers/infiniband/ulp/srpt/ib_srpt.c:48:39: fatal error: target/target_core_device.h: No such file or directory
> >
> > Caused by commit e0d85e515640 ("ib_srpt: Initial SRP Target merge for
> > v3.2-rc1") interacting with commit c4795fb20edf ("target: header
> > reshuffle, part2") from the target-updates tree which removed
> > include/target/target_core_device.h.
> >
> > I tried to figure out what set of include files is now needed, but
> > couldn't easily, so I have dropped the target-merge tree for today.
> 
> The (untested) patch below allowed me to make ib_srpt build again. By
> the way, has the patch "ib_srpt: Make compilation with BUG=n proceed"
> already been queued in the target-merge tree
> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg10030.html)
> ?
> 

Hi Bart,

I've included the above along with the patch to fix breakage using v3.3
includes in for-next-merge with ib_srpt.

Thanks!

--nab

