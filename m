Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1IVFb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 01:31:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58858 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1IVFbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 01:31:53 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: agruen@kernel.org, akpm@linux-foundation.org, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V6 00/26]  New ACL format for better NFSv4 acl interoperability
In-Reply-To: <20110921194531.GB23634@fieldses.org>
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <878vpi73oc.fsf@skywalker.in.ibm.com> <20110921194531.GB23634@fieldses.org>
User-Agent: Notmuch/0.8-16-gbdaee77 (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Thu, 22 Sep 2011 11:01:41 +0530
Message-ID: <87vcsl5eiq.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11092205-2398-0000-0000-00000065AC1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011 15:45:31 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Wed, Sep 21, 2011 at 01:00:43PM +0530, Aneesh Kumar K.V wrote:
> > On Mon,  5 Sep 2011 22:55:22 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > Hi,
> > > 
> > > The following set of patches implements VFS and ext4 changes needed to implement
> > > a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
> > > extended by file masks to fit into the standard POSIX file permission model.
> > > They are designed to work seamlessly locally as well as across the NFSv4 and
> > > CIFS/SMB2 network file system protocols.
> > > 
> > > A user-space utility for displaying and changing richacls is available at [4]
> > > (a number of examples can be found at http://acl.bestbits.at/richacl/examples.html).
> > > 
> > > [4] git://git.kernel.org/pub/scm/fs/acl/kvaneesh/richacl.git master
> > > 
> > > To test richacl on ext4 use -o richacl mount option. This mount option may later be
> > > dropped in favour of a feature flag.
> > > 
> > > More details regarding richacl can be found at
> > > http://acl.bestbits.at/richacl/
> > > 
> > > Changes from v5:
> > > a) rebase to v3.1-rc4-131-g9e79e3e
> > > 
> > > NOTE: The kernel changes will be pushed to
> > > git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-richacl.git richacl
> > > when kernel.org is back
> > > 
> > 
> > I pushed the kernel changes to
> > 
> > git://github.com/kvaneesh/linux.git richacl
> 
> Thanks!  This doesn't seem to have the branch with the followup patches
> for nfsd?
> 

richacl-fullset branch should have the full patchset including nfsd
changes. The changes are based on an older kernel version. Currently i
am planning to focus on the local file system and VFS changes so that we
can get that merged upstream.


-aneesh

