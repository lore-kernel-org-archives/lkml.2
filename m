Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172Ab2JXB7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 21:59:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab2JXB7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 21:59:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210232301160.2756@ionos>
References: <alpine.LFD.2.02.1210232301160.2756@ionos>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 23 Oct 2012 21:59:06 -0400
X-Google-Sender-Auth: t-vw0Lgdc4fMK1aJjuUjoysPtAw
Message-ID: <CAP=VYLqF4PPuZFwm9Ft_J_neLPNYv_a-2uZ3bi_cvQoxOQrH8A@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.6.3-rt6
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 5:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.6.3-rt6 release. rt6 is just an update
> to 3.6.3. The not announced 3.6.2-rt5 is an intermediate release with
> a single change.
>
> Changes since 3.6.2-rt4:
>
>         * Make the early printk changes work (hopefully) everywhere
>
> The new patch queue also contains a non code change (according to
> Pauls) which adds a missing subject line to a powerpc patch.

The rt5 and rt6 changes are now present in the 3.6-rt-patches repo.
Given the above, there is currently nothing for me to queue on a
separate  "-fixes" branch against rt6.  The master branch works as-is.

http://git.kernel.org/?p=linux/kernel/git/paulg/3.6-rt-patches.git;a=summary

Paul.
--

>
> The delta patch against 3.6.2-rt4 is appended below and can be found
> here:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.2-rt4-rt5.patch.xz
>
> The RT patch against 3.6.3 can be found here:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.3-rt6.patch.xz
>
> The split quilt queue is available at:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.3-rt6.tar.xz
>
> Enjoy,
>
>         tglx
>
> ---------->
