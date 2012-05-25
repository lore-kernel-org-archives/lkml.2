Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab2EYCke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:40:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58510 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2EYCkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:40:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120524170715.GB21355@gmail.com>
References: <20120523113432.GA12142@gmail.com>
	<CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
	<4FBD1AC8.7020602@zytor.com>
	<20120523174844.GA3373@gmail.com>
	<CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
	<4FBE5456.5020408@zytor.com>
	<CA+55aFyriUQCdEpa_YPBk-JvKAN26xC=MxWb3kO=xSkEou27dA@mail.gmail.com>
	<CANQmPXgxT3rvgGCOjztuGCTkgf4aa2-5a5q6K-8xPR1EcAsdgA@mail.gmail.com>
	<20120524170715.GB21355@gmail.com>
Date: Fri, 25 May 2012 10:40:32 +0800
Message-ID: <CANQmPXhSH3sGz670r7EmvhgZLX-fqGgEuO1N+6LVymC_p1SHyA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
From: Chen <hi3766691@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 1:07 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Interesting posts, first the "500K scheduler" nonsense now
> printk nonsense?

printk nonsense?  You actually read my words wrong(LAUGH!)
[I m going to quota my post]
* Chen <hi3766691@gmail.com> wrote:
> Everyone knows that this patch had been unstable. Also, too
> much code are pushed into printk() with the patch
>
I mean that too much code are brought with the patch.

500K scheduler is true. 248K(Core.c[MODULAR]) + 148K(fair.c[CFS]) +
47K(rt.c[RT])  = 443K.(Does not include the other source files of
scheduler.) It is really a *HUGE* CPU scheduler.[But it doesn't bring
much advantages to desktop!!]
