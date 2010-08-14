Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0HNCci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 22:32:38 -0400
Received: from xenotime.net ([72.52.115.56]:41589 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756795Ab0HNCcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 22:32:36 -0400
Date: Fri, 13 Aug 2010 19:32:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, hch@lst.de,
        akpm@linux-foundation.org, yehuda@hq.newdream.net
Subject: Re: [PATCH 0/8] rados block device and ceph refactor
Message-Id: <20100813193233.80f09131.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.64.1008131609270.5383@cobra.newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
	<20100813153706.ee61c94e.rdunlap@xenotime.net>
	<Pine.LNX.4.64.1008131609270.5383@cobra.newdream.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 16:11:55 -0700 (PDT) Sage Weil wrote:

> On Fri, 13 Aug 2010, Randy Dunlap wrote:
> > On Fri, 13 Aug 2010 10:40:32 -0700 Sage Weil wrote:
> > 
> > > Hi,
> > > 
> > > The rados block device (rbd) implements a network block device backed by 
> > > the Ceph distributed object store (think nbd/iSCSI, but distributed and 
> > > fault tolerant).  At the suggestion of Christoph and James, this version 
> > > of the patchset factors out the common Ceph bits (the network protocol, 
> > > cluster membership, and object storage parts) into a libceph module 
> > > (currently in net/ceph/ and include/linux/ceph/) that is shared by the 
> > > file system component (fs/ceph) and rbd (drivers/block/rbd.c). The first 
> > > few patches lay some groundwork, #7 moves does the ceph -> libceph+ceph 
> > > split, and #8 adds the block device driver.
> > 
> > Hi,
> > Did patch #7 make it to any mailing lists?
> > I didn't receive it.
> 
> Sorry, I think vger ate it (it's 850KB).  You can see it here:
> 
> http://git.kernel.org/?p=linux/kernel/git/sage/ceph-client.git;a=commit;h=a6da68196474aabcdcc2f5dab64c0b55ca5090b7

Yes, vger has a limit of 400 KB on lkml and netdev.
Other lists are probably less than that.

David M. wrote on 13-AUG-2007:

"The posting limit is 400K for linux-kernel, netdev, and one
or two of the other lists."

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
