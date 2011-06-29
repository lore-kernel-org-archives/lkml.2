Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1F2UEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:04:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1F2UEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:04:43 -0400
Date: Wed, 29 Jun 2011 16:04:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <andrea@betterlinux.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/8][V2] blk-throttle: Throttle buffered WRITEs in
 balance_dirty_pages()
Message-ID: <20110629200442.GC22301@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <20110628162138.GA1544@thinkpad>
 <20110628170624.GA12949@redhat.com>
 <20110629160532.GA1255@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629160532.GA1255@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 06:05:32PM +0200, Andrea Righi wrote:

[..]
> > > Have you tried to do some tests? (i.e. create multiple cgroups with very
> > > low I/O limit doing parallel O_DIRECT WRITEs, and try to run at the same
> > > time "ls" or other simple commands from the root cgroup or unlimited
> > > cgroup).
> > 
> > I did. On ext4, I created a cgroup with limit 1byte per second and 
> > started a direct write and did "ls", "sync" and some directory traversal
> > operations in same diretory and it seems to work.
> 
> Confirm. Everything seems to work fine also on my side.
> 
> Tested-by: Andrea Righi <andrea@betterlinux.com>
> 
> FYI, I've used the following script to test it if you're interested.
> I tested both with O_DIRECT=1 and O_DIRECT=0.

Thanks for testing these patches. This script looks good. Will save it.

Thanks
Vivek
