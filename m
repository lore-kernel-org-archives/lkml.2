Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1ESB1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:27:50 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59033 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1ESB1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xjppKxO482aM5aMeDEe8sNqd8I/7xkMMu1lWs4BoEmeuQEe/WFffkwR2aWJmwI8rew
         afU1cwze0O6s+7DSjcl8jkcOr89J0qRz2hX0sfaN5Vc6zdR4qpqq6fRw7Hxs1QPALwU+
         JMKbskgRSRP5AicPI6U+E8HDjfUR1qS+anprI=
MIME-Version: 1.0
In-Reply-To: <201105181047.17309.arnd@arndb.de>
References: <201105181047.17309.arnd@arndb.de>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 May 2011 09:27:27 +0800
Message-ID: <BANLkTim_0eRvDkQwAYjTNQsOVQiHV+DdBQ@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Arnd Bergmann <arnd@arndb.de>:
> This is the draft plan for maintaining the ARM subarchitectures in a common
> tree, as a way to help coordinate the upstream merging of the
> arch/arm/{plat,mach}-* changes into Linus' tree.
>
> This was discussed in great length at the Linaro Developer Summit in Budapest
> last week where we worked out an initial plan. We are modeling the maintainance
> after how the linux-tip tree is used for the x86 architecture, with a set
> of developers that have commit access to one tree on kernel.org and
> have mutual trust in one another. Nicolas Pitre and me are funded
> by Linaro to do the bulk of the work, while Thomas Gleixner will help
> us part-time with his long time architecture maintainance experience.
> Despite the funding by Linaro, this is not a Linaro project and all
> ARM subarchitectures are welcome to go through our tree.
>
> Russell King's role as ARM maintainer is of course unchanged by this, but
> he has the same commit access to the new tree as the other maintainers and
> is welcome to work in the same tree. We are also open to nominations for
> further people outside of Linaro to join us as committers. Marc Zyngier from
> ARM ltd is one of the candidates that has been suggested and I would also
> like to see someone from Google. We have to find the right balance with the
> number of committers so we get all the work done without stepping on each
> other's toes.
>
> Our tree will be strictly organized in topic brances so we can feed them
> upstream in the bitesized chunks that Linus likes. The master branch
> is an integration branch that pulls all other branches that are scheduled
> for the next merge window and itself gets integrated into linux-next.
>
> We will probably not be fully functional during the 2.6.40 merge window,
> but we are trying our best to be useful. For 2.6.41, my hope is that
> we can merge the bulk of the ARM subarchitecture changes through this
> tree. Once Linus is happy with the way that the process works, we can
> mandate that all ARM subarchitecture changes go through our tree, until
> then it stays voluntary.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
>
> Maintainers: If you are happy with the layout of the process,
> please ack this patch, otherwise please comment.
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8fce5e6..942d052 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -630,6 +630,17 @@ S: Maintained
>  F:     drivers/amba/
>  F:     include/linux/amba/bus.h
>
> +ARM SUBARCHITECTURES
> +M:     Arnd Bergmann <arnd@arndb.de>
> +M:     Nicolas Pitre <nico@fluxnic.net>
> +M:     Thomas Gleixner <tglx@linutronix.de>
> +M:     arm@kernel.org
> +L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:     MAINTAINEDftp.arm.linux.org.uk Git - linux-2.6-arm.git/summary
> +F:     arch/arm/mach-*/
> +F:     arch/arm/plat-*/
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-subarch.git
> +

does it mean if we want to add a new SoC plat/mach, we will send
patches againest this tree?
will this tree merge into rmk's tree? then rmk's tree will only manage
arm common codes?

>  ARM/ADI ROADRUNNER MACHINE SUPPORT
>  M:     Lennert Buytenhek <kernel@wantstofly.org>
>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
