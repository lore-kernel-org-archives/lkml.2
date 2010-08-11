Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0HKHxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:53:18 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44240 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab0HKHxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:53:17 -0400
Date: Wed, 11 Aug 2010 13:23:13 +0530
From: Sripathi Kodi <sripathik@in.ibm.com>
To: divya <dipraksh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kernel version 2.6.35-git10 build failure
Message-ID: <20100811132313.3d6c7f27@sripathi.in.ibm.com>
In-Reply-To: <4C624F7F.3070608@linux.vnet.ibm.com>
References: <4C624F7F.3070608@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 12:51:35 +0530
divya <dipraksh@linux.vnet.ibm.com> wrote:

> Hi,
> 
> Today kernel(version 2.6.35-git10 -commitid 3d30701b58970) build fails with following error on both system x and p
> 
>    fs/9p/vfs_inode.c: In function 'v9fs_vfs_setattr_dotl':
>    fs/9p/vfs_inode.c:1267: error: implicit declaration of function 'inode_setattr'
>    make[2]: *** [fs/9p/vfs_inode.o] Error 1
>    make[2]: *** Waiting for unfinished jobs....
>    make[1]: *** [fs/9p] Error 2
>    make[1]: *** Waiting for unfinished jobs....
>    make: *** [fs] Error 2
>    make: *** Waiting for unfinished jobs....
> 
> Seems like the commit 87d7845aa0b is the corrupt which added the function v9fs_vfs_setattr_dotl()

Yes, it is a problem I created. Stephen Rothwell has already fixed it.
Al Viro has sent a git pull request to Linus today with the fix in it.
Here is the patch you need: http://lkml.org/lkml/2010/6/21/442

Thanks,
Sripathi.

> 
> Thanks
> Divya
> 
> 
