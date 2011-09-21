Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1IUHax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 03:30:53 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55754 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1IUHav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 03:30:51 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        dhowells@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V6 00/26]  New ACL format for better NFSv4 acl interoperability
In-Reply-To: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Notmuch/0.8-16-gbdaee77 (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Wed, 21 Sep 2011 13:00:43 +0530
Message-ID: <878vpi73oc.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Sep 2011 22:55:22 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> Hi,
> 
> The following set of patches implements VFS and ext4 changes needed to implement
> a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
> extended by file masks to fit into the standard POSIX file permission model.
> They are designed to work seamlessly locally as well as across the NFSv4 and
> CIFS/SMB2 network file system protocols.
> 
> A user-space utility for displaying and changing richacls is available at [4]
> (a number of examples can be found at http://acl.bestbits.at/richacl/examples.html).
> 
> [4] git://git.kernel.org/pub/scm/fs/acl/kvaneesh/richacl.git master
> 
> To test richacl on ext4 use -o richacl mount option. This mount option may later be
> dropped in favour of a feature flag.
> 
> More details regarding richacl can be found at
> http://acl.bestbits.at/richacl/
> 
> Changes from v5:
> a) rebase to v3.1-rc4-131-g9e79e3e
> 
> NOTE: The kernel changes will be pushed to
> git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-richacl.git richacl
> when kernel.org is back
> 

I pushed the kernel changes to

git://github.com/kvaneesh/linux.git richacl

Userspace code can be found at 

git://github.com/kvaneesh/richacl-tools.git

-aneesh
