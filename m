Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab2JVBZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:25:07 -0400
Received: from ozlabs.org ([203.10.76.45]:48152 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab2JVBZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:25:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+55aFyDW4z5x8YcbQ8CYJvwHE3poK9iX8Sfgbg2fVaS3Bio4w@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com> <871ugwny1n.fsf@rustcorp.com.au> <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com> <87fw5bp858.fsf@rustcorp.com.au> <CA+55aFx339WquJEjijeRQ+12Aw0sa+MoL+kFttjbJLJ6S1Jy+Q@mail.gmail.com> <CA+55aFyDW4z5x8YcbQ8CYJvwHE3poK9iX8Sfgbg2fVaS3Bio4w@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Oct 2012 10:58:11 +1030
Message-ID: <877gqjjqp0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Fri, Oct 19, 2012 at 12:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Tssk. I fixed it up, and now it works-for-me(tm), but some perl person
>> probably really should try to make that sign-file and x509keyid merge.
>> My fix made the thing even slower, doing two extra "wc -c" invocations
>> since it can't do "${#..}" expansion due to the locale problem.
>
> Hmm. I haven't seen this breakage personally yet, but looking more at
> Rusty's last changes I'm pretty sure my fixes are potentially not
> sufficient.

Sorry for posting untested hack :(

Thanks for the rewrite David; modules_install here was 18.6 seconds,
became 19.1 with my broken hack, now 17.3 seconds.

Cheers,
Rusty.
