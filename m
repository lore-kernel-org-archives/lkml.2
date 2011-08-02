Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1HBKiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:38:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57243 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1HBKiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:38:02 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110802112907.5ca1abdd81758bd3b0bb6321@canb.auug.org.au>
References: <20110801144732.7f5204b219f628f2a2a63b0c@canb.auug.org.au>
	<CA+icZUXq9V6h6kJrjckpeDXQAbQ-skiKLwTjD7Luhz1mTqSM1w@mail.gmail.com>
	<20110801145422.cccff7aa.rdunlap@xenotime.net>
	<20110802112907.5ca1abdd81758bd3b0bb6321@canb.auug.org.au>
Date: Tue, 2 Aug 2011 12:38:01 +0200
Message-ID: <CA+icZUUDm+o+tikdVgGM3AGhjYdPSXPN+cQkQ8LT_h0+7n9uAQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 3:29 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> On Mon, 1 Aug 2011 14:54:22 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> On Mon, 1 Aug 2011 09:01:21 +0200 Sedat Dilek wrote:
>>
>> > Just FYI: mmotm-tree still misses the fixup-patch from [1].
>> >
>> > [1] https://patchwork.kernel.org/patch/1021602/
>>
>> Yes, I am applying this patch daily (among others).  :(
>>
>> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>
> OK, I will apply this patch to linux-next as a merge fixup on top of
> Andrew's tree.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Thanks for taking care, Stephen.
Just FYI: Andrew will carry the fix as
"consolidate-config_debug_strict_user_copy_checks-fix.patch" in his
tree.

- Sedat -
