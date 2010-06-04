Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0FDFnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:43:46 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:55158 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970Ab0FDFno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:43:44 -0400
Date: Fri, 4 Jun 2010 15:43:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V13 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100604054328.GA20641@dastard>
References: <1275581657-7232-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275581657-7232-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:44:06PM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> The below set of patches implement open by handle support using exportfs
> operations. This allows user space application to map a file name to file 
> handle and later open the file using handle. This should be usable
> for userspace NFS [1] and 9P server [2]. XFS already support this with the ioctls
> XFS_IOC_PATH_TO_HANDLE and XFS_IOC_OPEN_BY_HANDLE.
.....
> Example program: (x86_32). (x86_64 would need a different syscall number)

[snip test program]

Just a thought - can you write a set of tests using this (or
similar) test program and integrate them into xfstests?

That will help ensure correctness when implementing the API in other
filesystems (e.g. XFS ;), as well as provide some level of assurance
that we'll notice when we break the code...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
