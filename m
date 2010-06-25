Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab0FYEDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 00:03:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:56184 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0FYEDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 00:03:09 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTilxKwgVu_XdO3UwRtiRo1S9xJJuaeCsA7MyNOVn@mail.gmail.com>
References: <AANLkTilxKwgVu_XdO3UwRtiRo1S9xJJuaeCsA7MyNOVn@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 25 Jun 2010 00:02:48 -0400
Message-ID: <AANLkTimdcD_nAKZzPhZzOQo1v4fwVgIYDhHMzc7zrGX1@mail.gmail.com>
Subject: Re: New P2020-based board (mpc85xx) gets "Processor 1 is stuck" on 
	2.6.34, not on 2.6.32
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, put the old linuxppc list on the CC, sorry!

On Thu, Jun 24, 2010 at 23:32, Kyle Moffett <kyle@moffetthome.net> wrote:
> Hello,
>
> I'm working on a new board port for a P2020-based board, and I'm
> having problems with my second core not starting up on 2.6.34, even
> though it starts up fine on 2.6.32.
>
> In adding various debugs to mpc85xx_kick_cpu(), it looks like the
> virtual address is detected as 0x7ffff280 on both, and it seems to
> ioremap it to the same address.  Furthermore, both of them get the
> "ack" from the other CPU almost immediately (within 1ms).
> Unfortunately, after that the second core fails to rendezvous
> elsewhere in the SMP code and as a result I get "Processor 1 is
> stuck".
>
> Unfortunately I've had no luck looking through "git log
> v2.6.32..v2.6.34 -- arch/powerpc/" by hand, and there are enough
> mechanical merge conflicts with my patchset to make "bisection" very
> painful (IE: git bisect, git cherry-pick, test, git reset --hard
> HEAD^, repeat)
>
> Any additional suggestions on where to look would be much appreciated.
>
> Cheers,
> Kyle Moffett
>
