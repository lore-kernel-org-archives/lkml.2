Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1EBXX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:23:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab1EBXX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <web-516667715@zbackend1.aha.ru>
References: <web-516390660@zbackend1.aha.ru> <BANLkTikGZ8=qZauTfMxsOcXkCEq+X1TQUw@mail.gmail.com>
 <web-516667715@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 May 2011 16:23:03 -0700
Message-ID: <BANLkTimxj0Xt+05VWNx9D-WAaakR7b6AMQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>
Cc: jaxboe@fusionio.com, tj@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/2 werner <w.landgraf@ru.ru>:
>
> The unzip problem now didn't occure, I could unzip a 140 MB and a 460 MB
> file without it crashed.
>
> Actually it works stable? I have to continue to observe what happens.

Ok, please do continue to test to make sure.

Onc eyou are sure - and _if_ that kernel is stable - please then
enable CONFIG_IDE again, just to see whether it's CONFIG_IDE or the
CONFIG_X86_ELAN that causes the problems.

I suspect IDE (that would make more sense from the standpoint of where
the problem occurs), but we'd better make sure.

                          Linus
