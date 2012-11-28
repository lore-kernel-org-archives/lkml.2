Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2K1Qtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:49:32 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39603 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2K1Qt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:49:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxVyqScRU_c6RWVVub-tteuwjSq5JmThUtoxU-arBuh1w@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
 <CAPXgP12jXOJzTTgwQkm7XK_ig2iEKAbhgNkF+MRR6_S49Tqx_A@mail.gmail.com> <CA+55aFxVyqScRU_c6RWVVub-tteuwjSq5JmThUtoxU-arBuh1w@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 28 Nov 2012 17:49:06 +0100
Message-ID: <CAPXgP11teRC8bFNzF2NHJ78Bj-jf0fgRz++5vjeHVEHY=+Xe+A@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 5:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 28, 2012 at 8:22 AM, Kay Sievers <kay@vrfy.org> wrote:
>> On Wed, Nov 28, 2012 at 2:33 PM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>>
>>> On a 2.6.31 system, immediately after SYSLOG_ACTION_READ_CLEAR, a
>>> SYSLOG_ACTION_SIZE_UNREAD returns 0.
>>
>> Hmm, sounds like the right thing to do.
>
> Right.
>
> And that's the *OLD* behavior (2.6.31).

Ah, hmm, I read 2.6... as 3.6... :)

> So the new behavior is insane and different. Let's fix it.

Yeah.

> It looks like it is because the new SYSLOG_ACTION_SIZE_UNREAD code
> does not take the new clear_seq code into account. Hmm?

Right, something like that. I'll take a look now ...

Thanks,
Kay
