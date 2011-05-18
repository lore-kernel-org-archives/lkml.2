Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab1EROx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:53:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52278 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1EROx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wEnKZrgRXeQFeg0wz9LZ4ytgmLvz6wHwjpAXKZx8y+ZDew0Ly4JaVPiS6KmMElsqID
         y0YzBeDbQbLd88qU6cbgM84UeK1srLyEBXBKTW8UUwC6vqp1IQ9UesgZV831EhF9eu1y
         fkRzqv1FnANda9yUNPYBl+S9kXn78ttcNQZE8=
MIME-Version: 1.0
In-Reply-To: <201105181047.17309.arnd@arndb.de>
References: <201105181047.17309.arnd@arndb.de>
Date: Wed, 18 May 2011 15:53:27 +0100
X-Google-Sender-Auth: I6CesGurMSxeiYE47j0n8aN0290
Message-ID: <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 18 May 2011 09:47, Arnd Bergmann <arnd@arndb.de> wrote:
> This is the draft plan for maintaining the ARM subarchitectures in a common
> tree, as a way to help coordinate the upstream merging of the
> arch/arm/{plat,mach}-* changes into Linus' tree.

For clarification - the aim of this subarchitecture group is not only
to coordinate the upstream merging but also take an active (primary)
role in consolidating the existing code across various
subarchitectures under arch/arm/.

> We are also open to nominations for
> further people outside of Linaro to join us as committers. Marc Zyngier from
> ARM ltd is one of the candidates that has been suggested and I would also
> like to see someone from Google.

This looks fine to me.

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

With this additional line on ARM Ltd's behalf:

+M:     Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
(as co-maintainer of the RealView boards and major contributor to the
ARM architecture support code, though the latter isn't covered by this
group)

Thanks,

Catalin
