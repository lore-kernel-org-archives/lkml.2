Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1IZOl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:41:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50906 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1IZOly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <1317028849-13198-1-git-send-email-mcree@orcon.net.nz>
References: <1317028849-13198-1-git-send-email-mcree@orcon.net.nz>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 26 Sep 2011 10:41:34 -0400
Message-ID: <CAEdQ38GMtvqU7BN-EUg+Hy77ZLA=+A2oFpkv1EQQJthwRBhBsA@mail.gmail.com>
Subject: Re: [PATCH 0/2] alpha: implement missing syscalls
To: Michael Cree <mcree@orcon.net.nz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 5:20 AM, Michael Cree <mcree@orcon.net.nz> wrote:
> Andrew,
>
> Patches to implement missing syscalls on Alpha follow.  I am sending to you
> as the first one (the accept4 syscall) is really urgent and I am assuming
> that Matt's alpha-next repository is out of action at the moment.  If
> acceptable please forward to Linus.
>
> I have tested the accept4 syscall with the test code in commit
> de11defebf0000.
>
> The accept4 patch should also be sent to the stable queue. It would be good
> to get that into 3.0.x as that is the kernel currently in Debian Unstable
> where the missing accept4 syscall is starting to cause havoc.
>
> Cheers
> Michael.
>
> Michael Cree (2):
>  alpha: Wire up accept4 syscall.
>  alpha: Wire up sendmmsg syscall
>
>  arch/alpha/include/asm/unistd.h |    4 +++-
>  arch/alpha/kernel/systbls.S     |    2 ++
>  2 files changed, 5 insertions(+), 1 deletions(-)
>
> --

Both patches are
Reviewed-by: Matt Turner <mattst88@gmail.com>

Andrew, if you'd be so kind to take these, I'd be grateful.

Thanks,
Matt
