Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3ACQBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:01:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3ACQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:01:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: uapi __NR_syscalls for microblaze
Date: Thu, 3 Jan 2013 16:01:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arch@vger.kernel.org
References: <CAHTX3d+bwTNEhzB78mqoz6prk0nw0U_-1YFR3Tje_-uQLyTMBQ@mail.gmail.com> <26599.1357221783@warthog.procyon.org.uk> <CAHTX3d+C6_Vr-Q-UH8y9F_7=8GwBxzd8eECPN6tNBpxwr10=cQ@mail.gmail.com>
In-Reply-To: <CAHTX3d+C6_Vr-Q-UH8y9F_7=8GwBxzd8eECPN6tNBpxwr10=cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301031601.00594.arnd@arndb.de>
X-Provags-ID: V02:K0:fGvdQXovkN1YTxzryTDnJZhIgTOmrWEjBivcGJpLmCC
 Y7Vb9JjGdrENPK6zFcjA/A/3Jcy9YmD4O80m2Qpr0V+bho4L3I
 lYpYV3Re5+5kjGO65OYUkryIPDQiC10VhzV7wLflhCwa7nVdZn
 ZRFqXjj45rlO6NnXWIyd8XAnCLcuVLR3MYgJfhv/6ALoZLPK8i
 Alle3VKCELjBATc07al3oyExPrqp+h0JzgwQmXLseYiayLL5ei
 Lqt0sRj7uBC/SjTViR70NE+vtLbs4TntpnDUr93dQ0e6H8D6V7
 +UZoQzXEXoKYUBPalyZjAW/y8rnkADyF9pQ3qBa5DVnrn3uNLE
 hAvPtyr2gvK8Sp7KjYHU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013, Michal Simek wrote:
> 2013/1/3 David Howells <dhowells@redhat.com>:
> > Michal Simek <monstr@monstr.eu> wrote:
> >
> >> just want to check with you if __NR_syscalls is necessary for user space. I
> >> see that powerpc and arm have this macro in asm not in uapi like Microblaze.
> >> If is not needed by user space, I should move it to asm/unistd.h
> >
> > It isn't as far as I know...  I recommend putting your question on the
> > linux-arch mailing list.
> 
> I have add linux-arch to CC.

Right, I'm pretty sure it's not needed, but it has traditionally been
exported on a lot of platforms, so you can keep it in UAPI to be
on the safe side.

	Arnd
