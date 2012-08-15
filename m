Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2HOQg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:36:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58612 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2HOQg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:36:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120809083127.GC14102@arm.com>
References: <1344324343-3817-1-git-send-email-walken@google.com>
 <1344324343-3817-4-git-send-email-walken@google.com> <CANN689EOZ64V_AO8B6N0-_B0_HdQZVk3dH8Ce5c=m5Q=ySDKUg@mail.gmail.com>
 <20120809083127.GC14102@arm.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 15 Aug 2012 17:36:35 +0100
X-Google-Sender-Auth: mF8GJFA1G7WEnUx2sEcNcDFC0Jg
Message-ID: <CAHkRjk4pQOktEGFZy9Jd5NDth8f_+JUC0OrgcRUaCFGUEUOTKg@mail.gmail.com>
Subject: Re: [PATCH 3/5] kmemleak: use rbtree instead of prio tree
To: Michel Lespinasse <walken@google.com>
Cc: "riel@redhat.com" <riel@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vrajesh@umich.edu" <vrajesh@umich.edu>,
        "daniel.santos@pobox.com" <daniel.santos@pobox.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 August 2012 09:31, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Aug 08, 2012 at 06:07:39PM +0100, Michel Lespinasse wrote:
>> kmemleak uses a tree where each node represents an allocated memory object
>> in order to quickly find out what object a given address is part of.
>> However, the objects don't overlap, so rbtrees are a better choice than
>> prio tree for this use. They are both faster and have lower memory overhead.
>>
>> Tested by booting a kernel with kmemleak enabled, loading the kmemleak_test
>> module, and looking for the expected messages.
>>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>
> The patch looks fine to me but I'll give it a test later today and let
> you know.

Couldn't test it because the patch got messed up somewhere on the
email path (tabs replaced with spaces). Is there a Git tree I can grab
it from (or you could just send it to me separately as attachment)?

Thanks,

Catalin
