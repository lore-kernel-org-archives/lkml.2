Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0CXQAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:00:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49195 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0CXQAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:00:39 -0400
Date: Wed, 24 Mar 2010 16:00:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Benny Halevy <bhalevy@panasas.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT case to
 use of do_last()
Message-ID: <20100324160037.GP30031@ZenIV.linux.org.uk>
References: <4BAA3493.1030802@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA3493.1030802@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 05:49:39PM +0200, Boaz Harrosh wrote:
> - I have an exofs filesystem mounted on /mnt/exofs
> - []$ cd /mnt/exofs/some_linux_git; git status;
>   All is fine
> - []$ mount -t nfs4 -o minorversion=0 localhost:/ /mnt/nfs
>   (Where etc/exports will export /mnt/exofs via nfs4.1)
> - []$ cd /mnt/nfs/some_linux_git; git status;
>   This will fail and will corrupt the .git/index file. Sometimes the file would be
>   too short, and sometimes the file will become a directory (Yes really)

Bloody impressive...  Does that happen to underlying fs or to what you
are seeing via NFS?
