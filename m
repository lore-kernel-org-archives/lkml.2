Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0IGKWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:22:23 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:32857 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab0IGKWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:22:17 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V19 00/15] Generic name to handle and open by handle syscalls
In-Reply-To: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 07 Sep 2010 15:51:42 +0530
Message-ID: <m31v95zweh.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Aug 2010 16:32:47 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> Hi,
> 
> The below set of patches implement open by handle support using exportfs
> operations. This allows user space application to map a file name to file 
> handle and later open the file using handle. This should be usable
> for userspace NFS [1] and 9P server [2]. XFS already support this with the ioctls
> XFS_IOC_PATH_TO_HANDLE and XFS_IOC_OPEN_BY_HANDLE.
> 
> [1] http://nfs-ganesha.sourceforge.net/
> [2] http://thread.gmane.org/gmane.comp.emulators.qemu/68992
> 
> git repo for the patchset at:
> git://git.kernel.org/pub/scm/linux/kernel/git/kvaneesh/linux-open-handle.git open-by-handle
> 
> Test case can be found at
> http://git.kernel.org/?p=fs/ext2/kvaneesh/handle-test.git
> git://git.kernel.org/pub/scm/fs/ext2/kvaneesh/handle-test.git
> 
> Changes from V18:
> a) Drop open on symlink patch
> b) Drop other patches that added support for NULL pathname in *at syscalls
> c) Add new handle based syscalls. All of them are restricted to CAP_DAC_READ_SEARCH
> 

Hi Al,

Any update on this. Are you ok with syscall approach which is limitted to
CAP_DAC_READ_SEARCH  ?

-aneesh

