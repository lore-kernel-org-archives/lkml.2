Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2GQDdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:33:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54254 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2GQDdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:33:42 -0400
Subject: Re: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=utf-8
From: Chen Baozi <baozich@gmail.com>
In-Reply-To: <20120716151038.GI29979@sgi.com>
Date: Tue, 17 Jul 2012 11:33:33 +0800
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Content-Transfer-Encoding: 8BIT
Message-Id: <5292013E-6FF3-47F6-BE9F-FD7BA2BB2AA9@gmail.com>
References: <1342208293-3405-1-git-send-email-baozich@gmail.com> <20120716151038.GI29979@sgi.com>
To: Ben Myers <bpm@sgi.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,
On Jul 16, 2012, at 11:10 PM, Ben Myers wrote:

> Hey Chen,
> 
> On Sat, Jul 14, 2012 at 03:38:13AM +0800, Chen Baozi wrote:
>> Fix trivial typo error that has written "It" to "Is".
>> 
>> Signed-off-by: Chen Baozi <baozich@gmail.com>
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> Thanks for the patch!  I'm happy you're working on XFS.  Do you have any
> time/interest in taking on a work item or two?  I have a few would-be-nices
> which I've made notes of, and I'm sure that Dave or Christoph could also think
> of a few if you're interested.
I'd really love to. Right now, I am working on syslinux to support booting on xfs partition (under pcacjr's mentoring)， which I thought would be a nice start to get familiar with xfs (and I did learn a lot from it). So I think there would be more time (and experience on xfs) after I finish the xfs support on syslinux. And I'm really looking forward to your ideas. So do please tell me what I can help, I'll try my best to do it. 

Thanks a lot.

Baozi
> 
> Thanks again,
> -Ben
> 
>> ---
>> fs/xfs/xfs_da_btree.h |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
>> index dbf7c07..be30bd4 100644
>> --- a/fs/xfs/xfs_da_btree.h
>> +++ b/fs/xfs/xfs_da_btree.h
>> @@ -32,7 +32,7 @@ struct zone;
>> /*
>>  * This structure is common to both leaf nodes and non-leaf nodes in the Btree.
>>  *
>> - * Is is used to manage a doubly linked list of all blocks at the same
>> + * It is used to manage a doubly linked list of all blocks at the same
>>  * level in the Btree, and to identify which type of block this is.
>>  */
>> #define XFS_DA_NODE_MAGIC	0xfebe	/* magic number: non-leaf blocks */
>> -- 
>> 1.7.1
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

