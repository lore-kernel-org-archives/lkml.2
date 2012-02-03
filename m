Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab2BCB3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:29:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab2BCB3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:29:09 -0500
Message-ID: <4F2B38FD.50902@redhat.com>
Date: Fri, 03 Feb 2012 09:31:41 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
References: <20120201063420.GA10204@darkstar.nay.redhat.com>	<20120201131746.07e2219e.akpm@linux-foundation.org>	<CABqxG0fyH89YP+jpZ5nJoVfzOQ++J4EfGP42FtjxAv7OY9o+5w@mail.gmail.com> <20120202115628.46150903.akpm@linux-foundation.org>
In-Reply-To: <20120202115628.46150903.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 03:56 AM, Andrew Morton wrote:

> On Thu, 2 Feb 2012 10:13:43 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
> 
>> On Thu, Feb 2, 2012 at 5:17 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Wed, 1 Feb 2012 14:34:20 +0800
>>> Dave Young <dyoung@redhat.com> wrote:
>>>
>>>> tools/ is the better place for vm tools which are used by many people.
>>>> Moving them to tools also make them open to more users instead of hide in
>>>> Documentation folder.
>>>>
>>>
>>> It would be nice to covert these into simple pass/fail tests and
>>> promote them to tools/testing/selftests/.
>>
>> Andrew, I'm not clear about this, do you means to selftest
>> hugepage-mmap.c,  hugepage-shm.c  and map_hugetlb.c?
> 
> Those ones can go into selftests.
> 
>> I think slabinfo and page-types should stay in tools/vm/.
> 
> Yes, those are tools, not selftests.


Great, thanks for explain, will do

-- 
Thanks
Dave
