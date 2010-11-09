Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0KIWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:01:53 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48661 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0KIWBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:01:52 -0500
Date: Tue, 9 Nov 2010 16:01:44 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] ecryptfs fixes
Message-ID: <20101109220144.GA3599@boyd.l.tihix.com>
References: <201011031111.06669.roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011031111.06669.roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Nov 03, 2010 at 11:11:06AM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> This patch set applies to the latest kernel 2.6.37-rc1.
> 
> 
> Roberto Sassu (5):
>   ecryptfs: moved ECRYPTFS_SUPER_MAGIC definition to linux/magic.h
>   ecryptfs: missing initialization of the superblock 'magic' field
>   ecryptfs: test lower_file pointer when lower_file_mutex is locked
>   ecryptfs: fixed testing of file descriptor flags
>   ecryptfs: open lower files with kthread credentials

Hey Roberto - I pushed these patches to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Thanks,
Tyler

> 
>  fs/ecryptfs/ecryptfs_kernel.h |    4 +---
>  fs/ecryptfs/file.c            |   20 +++++++++-----------
>  fs/ecryptfs/inode.c           |   32 ++++++++++++++------------------
>  fs/ecryptfs/kthread.c         |   17 +++++++++++++----
>  fs/ecryptfs/main.c            |    5 +++--
>  include/linux/magic.h         |    1 +
>  6 files changed, 41 insertions(+), 38 deletions(-)
> 
> -- 
> 1.7.2.3


