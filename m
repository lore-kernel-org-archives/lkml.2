Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0FDGIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:08:46 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51051 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0FDGIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:08:44 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V13 0/11] Generic name to handle and open by handle syscalls
In-Reply-To: <20100604054328.GA20641@dastard>
References: <1275581657-7232-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100604054328.GA20641@dastard>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 04 Jun 2010 11:38:39 +0530
Message-ID: <877hmfib2w.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 15:43:28 +1000, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 03, 2010 at 09:44:06PM +0530, Aneesh Kumar K.V wrote:
> > Hi,
> > 
> > The below set of patches implement open by handle support using exportfs
> > operations. This allows user space application to map a file name to file 
> > handle and later open the file using handle. This should be usable
> > for userspace NFS [1] and 9P server [2]. XFS already support this with the ioctls
> > XFS_IOC_PATH_TO_HANDLE and XFS_IOC_OPEN_BY_HANDLE.
> .....
> > Example program: (x86_32). (x86_64 would need a different syscall number)
> 
> [snip test program]
> 
> Just a thought - can you write a set of tests using this (or
> similar) test program and integrate them into xfstests?
> 
> That will help ensure correctness when implementing the API in other
> filesystems (e.g. XFS ;), as well as provide some level of assurance
> that we'll notice when we break the code...
> 

Will do. I also have test that test for different open flags with
open_by_handle_at. Will add those tests also.

-aneesh
