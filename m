Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0IQRSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:18:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59377 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab0IQRSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:18:44 -0400
Date: Fri, 17 Sep 2010 10:18:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk
Subject: Re: [linux-next] fs/ocfs2/file.c:201: error: =?UTF-8?B?4oCYQkxL?=
 =?UTF-8?B?REVWX0lGTF9XQUlU4oCZ?= undeclared (first use in this function)
Message-Id: <20100917101828.813e4515.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimeZyZstBR4ZRxJg3OaP_aibLqQtYw2dTJ7cq7c@mail.gmail.com>
References: <AANLkTimeZyZstBR4ZRxJg3OaP_aibLqQtYw2dTJ7cq7c@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010 17:36:43 +0200 Sedat Dilek wrote:

> Hi,
> 
> I pulled linux-2.6-block/for-next into mainline.
> 
> The build breaks, the issue is known [1] (but I didnt see a patch):

Just a verbal patch, yes.

> [ build.log ]
> ...
> /home/sd/src/linux-2.6/linux-2.6.36-rc4/debian/build/source_i386_none/fs/ocfs2/file.c:201:
> error: ‘BLKDEV_IFL_WAIT’ undeclared (first use in this function)
> /home/sd/src/linux-2.6/linux-2.6.36-rc4/debian/build/source_i386_none/fs/ocfs2/file.c:201:
> error: (Each undeclared identifier is reported only once
> /home/sd/src/linux-2.6/linux-2.6.36-rc4/debian/build/source_i386_none/fs/ocfs2/file.c:201:
> error: for each function it appears in.)
> /home/sd/src/linux-2.6/linux-2.6.36-rc4/debian/build/source_i386_none/fs/ocfs2/file.c:201:
> error: too many arguments to function ‘blkdev_issue_flush’
>   CC [M]  net/rxrpc/ar-error.o
>   CC [M]  drivers/scsi/scsi_error.o
> make[3]: *** [sub-make] Error 2
> make[2]: *** [all] Error 2
> 
> Regards,
> - Sedat -
> 
> [1] http://www.spinics.net/lists/linux-next/msg11970.html
> 
> P.S.: Is there an email-address for linux-next (did not see in MAINTAINERS)?

http://vger.kernel.org/vger-lists.html#linux-next

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
