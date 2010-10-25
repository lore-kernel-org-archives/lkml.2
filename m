Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab0JYTJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:09:17 -0400
Received: from fieldses.org ([174.143.236.118]:49104 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889Ab0JYTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:09:16 -0400
Date: Mon, 25 Oct 2010 15:09:02 -0400
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
        sandeen@redhat.com, tytso@mit.edu, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH -V4 00/11]  New ACL format for better NFSv4 acl
 interoperability
Message-ID: <20101025190901.GA13523@fieldses.org>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20101012002409.GH16442@fieldses.org>
 <m3bp6zswvh.fsf@linux.vnet.ibm.com>
 <20101012153507.GC12752@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012153507.GC12752@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 11:35:07AM -0400, J. Bruce Fields wrote:
> On Tue, Oct 12, 2010 at 12:47:38PM +0530, Aneesh Kumar K. V wrote:
> > What we need in the first step is to get VFS changes reviewed.Once we
> > agree on the VFS changes done, then we can start looking at the changes
> > upto NFS richacl nfs support. When get that merged then we can start
> > having discussion on how local file system maintainers want to migrate
> > the existing file system with posixacl to richacl.
> 
> OK.  So, personally: I'm resigned to the idea that we want support for
> this ACL model.  The vfs changes look OK to me (and wouldn't be changed
> by any comments I'd have on the more richacl-specific patches to
> follow).  So that's an ACK from me on the first set of these patches,
> assuming it's OK with people to merge these things one step at a time.

Is there any progress on this?

--b.
