Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178Ab2ERMGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:06:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55241 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab2ERMGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:06:36 -0400
MIME-Version: 1.0
In-Reply-To: <29366.1337341984@redhat.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
	<1337292816-10839-9-git-send-email-hjl.tools@gmail.com>
	<4FB58EFD.7010302@zytor.com>
	<4FB5C050.9070805@kernel.org>
	<CAMe9rOrKq8Ait8wKudRF535J5c=dDTKekmUN_=HOs5BBLtsoGQ@mail.gmail.com>
	<CA+55aFxtejaM8ecOw8VYk74OaXfGY7=LO3JSyz3rdHEv2r9goQ@mail.gmail.com>
	<4FB5C843.9070002@kernel.org>
	<29366.1337341984@redhat.com>
Date: Fri, 18 May 2012 05:06:35 -0700
Message-ID: <CAMe9rOoU=2ma7e+sbfCV1Ca10_XCRY44DS7OJgFq79sNuXoo0A@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
From: "H.J. Lu" <hjl.tools@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 4:53 AM, David Howells <dhowells@redhat.com> wrote:
> H. Peter Anvin <hpa@kernel.org> wrote:
>
>> User mode can, and should, be able to use the exported headers.  David
>> Howells have been doing even more work to distill out the actual
>> exported ABIs from the kernel and remove remaining chaff.
>
> See:
>
>        http://git.infradead.org/users/dhowells/linux-headers.git/shortlog/refs/heads/uapi-split
>
> Linus: Any chance of this being pulled at the end of the next merge window?  I
> know you said you didn't want to do another big header file cleanup for a
> while after pulling the system.h disintegration, but I'm wondering if your
> distaste has expired yet.
>

As shown by x32, the kernel interface types are really arch-dependent.
Any generic types based on long won't work for x32.


-- 
H.J.
