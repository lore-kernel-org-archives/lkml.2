Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1BNRuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:50:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208Ab1BNRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:50:21 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <m1hbce46fw.fsf@fess.ebiederm.org> <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
 <m1bp2ly41q.fsf@fess.ebiederm.org> <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
 <AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
 <AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
 <m14o87wev8.fsf@fess.ebiederm.org> <AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
 <m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org>
 <m139nqsk3q.fsf@fess.ebiederm.org> <AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Feb 2011 09:49:33 -0800
Message-ID: <AANLkTimwbkQQkwcX19NVcmSfv5O1dP9oeEBegbQLSh60@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 8:37 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> In other words: I can pretty much guarantee that this is a "struct
> list" that is in a 8kB allocation at offset 0x1748. And that gets
> re-initialized after it got freed.

Btw, can you just make that 'vmlinux' image (not the compressed one,
the actual final object file that I could do "objdump" on) available
somewhere, or just send me the .config file to try to reproduce it
closely enough to see what the 0x1748 offset might be.

As mentioned, those offsets change (often wildly) depending on config
options, and I don't think I've seen the .config file you have (or if
I've seen it, I've misplaced it).

                             Linus
