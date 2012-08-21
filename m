Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab2HULCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:02:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62513 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2HULCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:02:48 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 21 Aug 2012 13:02:46 +0200
Message-ID: <CA+icZUWg7qEFvAsTMb9OFKmdW7XD4op14Ps2y6PLByZRArjeLg@mail.gmail.com>
Subject: Re: inux-next: Tree for Aug 21 (call-trace when suspending: PM?)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 8:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20120820:
>
> The rr tree gained a conflict against Linus' tree.
>
> The tip tree still has its build failure so I used the version from
> next-20120814.
>
> The workqueues tree gained a conflict against the hid tree.
>
> The drivers-x86 tree still has its build failure so I used the version
> from next-20120817.
>
> The signal tree gained a conflict against Linus' tree.  I have still
> reverted 3 commits from the signal tree at the request of the arm
> maintainer.
>
> ----------------------------------------------------------------------------
>

Hi,

I have compiled linux-next (next-20120821) and see the attached
call-trace when suspending.
Suspending did NOT work (Xorg seems to cause it) - machine came back to desktop.

With yesterday's next-20120820 I haven't seen this.

I am not sure what is this causing... PM, x86/sched or even VFS?
Any help for debugging appreciated.

I am on Ubuntu/precise AMD64 and use systemd-v43 as init-system.

Regards,
- Sedat -
