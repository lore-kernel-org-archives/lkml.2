Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab0HKHVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:21:38 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:39835 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0HKHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:21:37 -0400
Message-ID: <4C624F7F.3070608@linux.vnet.ibm.com>
Date: Wed, 11 Aug 2010 12:51:35 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        sripathik@in.ibm.com
Subject: kernel version 2.6.35-git10 build failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today kernel(version 2.6.35-git10 -commitid 3d30701b58970) build fails with following error on both system x and p

   fs/9p/vfs_inode.c: In function 'v9fs_vfs_setattr_dotl':
   fs/9p/vfs_inode.c:1267: error: implicit declaration of function 'inode_setattr'
   make[2]: *** [fs/9p/vfs_inode.o] Error 1
   make[2]: *** Waiting for unfinished jobs....
   make[1]: *** [fs/9p] Error 2
   make[1]: *** Waiting for unfinished jobs....
   make: *** [fs] Error 2
   make: *** Waiting for unfinished jobs....

Seems like the commit 87d7845aa0b is the corrupt which added the function v9fs_vfs_setattr_dotl()

Thanks
Divya


