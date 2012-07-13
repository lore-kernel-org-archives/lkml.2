Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2GMXJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 19:09:14 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39300 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2GMXJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 19:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120713154519.60a686e8.akpm@linux-foundation.org>
References: <1342139517-3451-1-git-send-email-walken@google.com>
	<1342139517-3451-6-git-send-email-walken@google.com>
	<20120713131514.86ab4df4.akpm@linux-foundation.org>
	<CANN689FUm83vGFVF30Lg52_28vxdY+mZ88jVCGpmVfiHiHwNtg@mail.gmail.com>
	<20120713154519.60a686e8.akpm@linux-foundation.org>
Date: Fri, 13 Jul 2012 16:09:11 -0700
Message-ID: <CANN689HSZqpsiOAMpKe_4=TWNhv7YPkiE5pqpnq1QQKkCiHm6Q@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] rbtree: performance and correctness test
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 3:45 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 13 Jul 2012 15:33:35 -0700 Michel Lespinasse <walken@google.com> wrote:
>> Ah, I did not realize we had a precedent for in-tree kernel test modules.
>
> hm, well, just because that's what we do now doesn't mean that it was a
> good idea ;) These things arrive as a result of individual developers
> doing stuff in their little directories and no particular thought was
> put into overall structure.
>
> It could be that it would be better to put all these tests into a
> central place, rather than sprinkling them around the tree.  If so,
> then your patch can lead the way, and we (ie: I) prod past and future
> developers into getting with the program.
>
> otoh, perhaps in-kernel test modules will rely on headers and constants
> which are private to the implementation directory.  So perhaps
> sprinkled-everywhere is the best approach.

I think it is at least reasonable. Where we could improve, however,
would be on the Kconfig side of things.

>> I don't think my proposal was significantly better than this
>> precedent, so I'll just adjust my patch to conform to it:
>> - move rbtree_test.c to lib/
>> - modify just lib/Makefile and lib/Kconfig.debug to get the module built.
>>
>> Will send a replacement patch for this (so you can drop that one patch
>> from the stack and replace it with)
>
> OK, you could do that too.  That way you avoid the problem and we can
> worry about it later (if ever), as a separate activity.

Going to attach as a reply to this email.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
