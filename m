Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0HMWhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:37:09 -0400
Received: from xenotime.net ([72.52.115.56]:44439 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755698Ab0HMWhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:37:07 -0400
Date: Fri, 13 Aug 2010 15:37:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, hch@lst.de,
        akpm@linux-foundation.org, yehuda@hq.newdream.net
Subject: Re: [PATCH 0/8] rados block device and ceph refactor
Message-Id: <20100813153706.ee61c94e.rdunlap@xenotime.net>
In-Reply-To: <1281721240-26130-1-git-send-email-sage@newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 10:40:32 -0700 Sage Weil wrote:

> Hi,
> 
> The rados block device (rbd) implements a network block device backed by 
> the Ceph distributed object store (think nbd/iSCSI, but distributed and 
> fault tolerant).  At the suggestion of Christoph and James, this version 
> of the patchset factors out the common Ceph bits (the network protocol, 
> cluster membership, and object storage parts) into a libceph module 
> (currently in net/ceph/ and include/linux/ceph/) that is shared by the 
> file system component (fs/ceph) and rbd (drivers/block/rbd.c). The first 
> few patches lay some groundwork, #7 moves does the ceph -> libceph+ceph 
> split, and #8 adds the block device driver.

Hi,
Did patch #7 make it to any mailing lists?
I didn't receive it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
