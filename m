Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1EDKJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 06:09:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58781 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1EDKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 06:09:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=L/OOwtDgPxk2Bu4Tlo0VpHey9G0F7J95M4FH33ILKvYn7ShfZmSw5Zd0pR578R9hN2
         oFfKrnlHbtm7xw0fa5G6A9nSVtYXb26DnIx5ECRB+JOqEg/BhglwEeRlxSfEd1AwO9QK
         2nXJBF4uNUOvpvV6YQ7dLZ79jh2qCX17+J9lQ=
MIME-Version: 1.0
Date: Wed, 4 May 2011 15:39:00 +0530
Message-ID: <BANLkTimLd-qY-OeKqnf2EoTfvAHWQZVchw@mail.gmail.com>
Subject: [ARM]crash on 2.6.35.11
From: naveen yadav <yad.naveen@gmail.com>
To: linux-mm <linux-mm@kvack.org>, linux-arm-request@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

We are running linux kernel 2.6.35.11 on Cortex a-8. when I run a
simple program expect to give oom.
 But it crash with following crash log

./DiffSize

BUG: Bad page state in process DiffSize  pfn:50769c
page:c9907380 count:892679477 mapcount:892679478 mapping:35353535
index:0x35353535
page flags: 0x35353535(locked|referenced|dirty|lru|owner_priv_1|reserved|private_2|writeback|swapcache|reclaim|swapbacked|unevictable)
Backtrace:
[<c0023b90>] (dump_backtrace+0x0/0x110) from [<c02de8f0>] (dump_stack+0x18/0x1c)
 r6:c9907380 r5:c040674c r4:c9907380 r3:00000000
[<c02de8d8>] (dump_stack+0x0/0x1c) from [<c007b60c>] (bad_page+0xe0/0x10c)
[<c007b52c>] (bad_page+0x0/0x10c) from [<c007c864>]
(get_page_from_freelist+0x364/0x4bc)
 r5:c03cd21c r4:00000000
[<c007c500>] (get_page_from_freelist+0x0/0x4bc) from [<c007cac8>]
(__alloc_pages_nodemask+0x10c/0x578)
[<c007c9bc>] (__alloc_pages_nodemask+0x0/0x578) from [<c008b3e0>]
(handle_mm_fault+0x218/0xd68)
[<c008b1c8>] (handle_mm_fault+0x0/0xd68) from [<c0026514>]
(do_page_fault+0x10c/0x200)
[<c0026408>] (do_page_fault+0x0/0x200) from [<c001f2bc>]
(do_DataAbort+0x3c/0xa0)
[<c001f280>] (do_DataAbort+0x0/0xa0) from [<c001ff24>]
(ret_from_exception+0x0/0x10)
Exception stack(0xc9281fb0 to 0xc9281ff8)
1fa0:                                     48166008 00000035 50166008 35353535
1fc0: 072be000 35353535 48ea7f88 4001f080 00000000 00000000 be87e880 be87e86c
1fe0: 48ea8008 be87e844 00008514 400b449c 20000010 ffffffff
 r7:4001f080 r6:48ea7f88 r5:35353535 r4:ffffffff
Disabling lock debugging due to kernel taint

regards
Naveen
