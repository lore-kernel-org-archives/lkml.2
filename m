Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1BHUpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:45:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565Ab1BHUpK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <m1hbce46fw.fsf@fess.ebiederm.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com> <m1hbce46fw.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Feb 2011 12:44:17 -0800
Message-ID: <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 12:28 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> A quick heads up.  2.6.38-rc4 looks like the worst kernel I've ever tried to
> test.  It boots up properly and looks ok, but I can't get it to even
> compile the programs I usually test with. 2.6.38-rc3 at least managed
> that yesterday.

gcc dying with ICE or SIGSEGV? Or what? Seriously lacking information here.

Are you using btrfs or cifs (the two filesystems that had
bigger-than-average changes)?

Any chance to bisect it (even if just partially - a couple of
bisection runs would already narrow it down quite a bit)?

> From 2.6.38-rc3 I managed to figure out that tftp transfers over ipv6
> with curl are dying in with a getpeername problem.

Hmm. Adding Davem for that one, although I'd expect you to be able to
figure out some networking problem on your own and perhaps give a
better report?

                             Linus
