Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab1CDTY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:24:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547Ab1CDTY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:24:27 -0500
MIME-Version: 1.0
In-Reply-To: <201103041959.57966.vda.linux@googlemail.com>
References: <20110301152457.GE26074@htj.dyndns.org> <AANLkTinn_J3fxyjgQk02mHpbxh_5fXNk1qT-YwjgCGqK@mail.gmail.com>
 <AANLkTinwo05bRQ8YE2-gmD0cY-8ML7vkiCkbhWOWn+=C@mail.gmail.com> <201103041959.57966.vda.linux@googlemail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Mar 2011 11:24:06 -0800
Message-ID: <AANLkTinr3p=LfbunSNFhPbcnhDwd-2us6wGkj4Otqk+f@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 10:59 AM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
>>
>> That should get the whole "user_regs_struct" in one single system call.
>
> Aye. That's the idea: get more info in one go.

My point is that it's totally idiotic to start talking about new
kernel interfaces, when strace doesn't even use the ones we HAVE, and
have had for a long time.

So the strace use is clearly not a valid reason to start worrying
about new interfaces. It doesn't even care about all the improvements
we've done several years ago.

                     Linus
