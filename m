Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2BBCOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:14:06 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46549 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367Ab2BBCNo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:13:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120201131746.07e2219e.akpm@linux-foundation.org>
References: <20120201063420.GA10204@darkstar.nay.redhat.com>
	<20120201131746.07e2219e.akpm@linux-foundation.org>
Date: Thu, 2 Feb 2012 10:13:43 +0800
Message-ID: <CABqxG0fyH89YP+jpZ5nJoVfzOQ++J4EfGP42FtjxAv7OY9o+5w@mail.gmail.com>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 5:17 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 1 Feb 2012 14:34:20 +0800
> Dave Young <dyoung@redhat.com> wrote:
>
>> tools/ is the better place for vm tools which are used by many people.
>> Moving them to tools also make them open to more users instead of hide in
>> Documentation folder.
>>
>
> It would be nice to covert these into simple pass/fail tests and
> promote them to tools/testing/selftests/.

Andrew, I'm not clear about this, do you means to selftest
hugepage-mmap.c,  hugepage-shm.c  and map_hugetlb.c? I think slabinfo
and page-types should stay in tools/vm/. Can you explain a bit?

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards
Dave
