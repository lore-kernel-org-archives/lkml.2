Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1EWRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab1EWRZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:25:56 -0400
Date: Mon, 23 May 2011 19:23:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: ptrace_resume->wake_up_process (Was: Ptrace documentation,
	draft #1)
Message-ID: <20110523172352.GA30226@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com> <BANLkTintE-QVUJhJY-_A5nvgj7viJatZ4Q@mail.gmail.com> <20110519194908.GA26584@redhat.com> <BANLkTi=bRb+NCqqS9+ptzxHVOjKKXhZgsg@mail.gmail.com> <20110523121011.GA5799@redhat.com> <20110523141034.GA11866@redhat.com> <BANLkTimaN8U8_sWT_q_ZDZkA51jqWPHkiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimaN8U8_sWT_q_ZDZkA51jqWPHkiQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23, Linus Torvalds wrote:
>
> On Mon, May 23, 2011 at 7:10 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > In fact ptrace_resume()->wake_up_process() is obviously wrong anyway,
> > I think the patch below makes sense even for 2.6.40.
>
> Send me a signed-off version with a somewhat cleaned-up commit
> message, and we can make that happen.

Ah, I sent the patch a minute ago.

> Or a pull request ..

Whatever is more convenient for you. If everyone agree with this change,
I'll add it to ptrace branch and send [GIT PULL] tomorrow.

Oleg.

