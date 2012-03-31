Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab2CaBSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 21:18:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51188 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143Ab2CaBSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 21:18:42 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CA+55aFzeN+m0mWqe6ajBB=cdTNJMF2FgW17_mm_n0BoKokQVRw@mail.gmail.com>
References: <CAOesGMjU5tehTf7+nYQv1_7a=+gGN2hVYUdh1g_BF=WRYj0hgg@mail.gmail.com>
	<CA+55aFzeN+m0mWqe6ajBB=cdTNJMF2FgW17_mm_n0BoKokQVRw@mail.gmail.com>
Date: Fri, 30 Mar 2012 18:18:40 -0700
Message-ID: <CAOesGMhrokqQajQ6RROXdWNvVUd3WNjO4i3qggGAVXo5h05TKQ@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: Two more fixes for merge window fallout
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 5:00 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 30, 2012 at 4:20 PM, Olof Johansson <olof@lixom.net> wrote:
>>
>> are available in the git repository at:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes
>
> Hmm. I *think* you meant to ask me to pull the "fixes-for-linus" tag,
> which points at the same commit as the "fixes" branch. No?

Yes, that's correct.

> You might want to double-check whatever script or workflow you use to
> generate these pull requests.

Hmm, I had 'fixes' checked out locally, and used regular git request-pull.

Oh! I know what it was. I pushed the branch before I pushed the tag,
so when I generated the request the branch had propagated out from ra
to git.kernel.org but not the tag.

Since the branch matched but no tag did, request-pull used it and took
the local tag contents for the message so I didn't notice the
difference.

Thanks for the sanity check, I'll double-check in the future.


-Olof
