Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0JZEfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 00:35:50 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44084 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab0JZEft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 00:35:49 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
        sandeen@redhat.com, tytso@mit.edu, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH -V4 00/11]  New ACL format for better NFSv4 acl interoperability
In-Reply-To: <20101025190901.GA13523@fieldses.org>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20101012002409.GH16442@fieldses.org> <m3bp6zswvh.fsf@linux.vnet.ibm.com> <20101012153507.GC12752@fieldses.org> <20101025190901.GA13523@fieldses.org>
User-Agent: Notmuch/0.3.1-90-g8071c5c (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 26 Oct 2010 10:05:37 +0530
Message-ID: <m3k4l5lgfa.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 15:09:02 -0400, "J. Bruce Fields" <bfields@citi.umich.edu> wrote:
> On Tue, Oct 12, 2010 at 11:35:07AM -0400, J. Bruce Fields wrote:
> > On Tue, Oct 12, 2010 at 12:47:38PM +0530, Aneesh Kumar K. V wrote:
> > > What we need in the first step is to get VFS changes reviewed.Once we
> > > agree on the VFS changes done, then we can start looking at the changes
> > > upto NFS richacl nfs support. When get that merged then we can start
> > > having discussion on how local file system maintainers want to migrate
> > > the existing file system with posixacl to richacl.
> > 
> > OK.  So, personally: I'm resigned to the idea that we want support for
> > this ACL model.  The vfs changes look OK to me (and wouldn't be changed
> > by any comments I'd have on the more richacl-specific patches to
> > follow).  So that's an ACK from me on the first set of these patches,
> > assuming it's OK with people to merge these things one step at a time.
> 
> Is there any progress on this?
> 

The next step would be to get Al Viro or Christoph to look at the
proposed VFS changes and get an ACK on them. Meanwhile i can rebase
the full series to the latest linux kernel. 

Apart from that is there any specific changes you would like to see
as a part of richacl patch series. Would you like to see the full
patchset posted to the list or should we go in steps as mentioned above
?

-aneesh
