Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2LMQFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:05:48 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33971 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab2LMQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:05:45 -0500
MIME-Version: 1.0
In-Reply-To: <50C9040C.20708@zytor.com>
References: <20121211111026.GA26507@gmail.com> <CA+55aFzJX-EKC4Z98+KEaca0V27p8PxqZXiPox=TuuhytUTziw@mail.gmail.com>
 <50C8D458.4050006@zytor.com> <50C9040C.20708@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Dec 2012 08:05:24 -0800
X-Google-Sender-Auth: 3E-ysjDGOy6s4dx7TZfEHsc_nfk
Message-ID: <CA+55aFzLmqv651mZT1GOKHozxUmUwgRyPQ9sQj9LwvOszJ6L7g@mail.gmail.com>
Subject: Re: [RFC GIT PULL] "Nuke 386-DX/SX support" changes for v3.8
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 2:24 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Well... it turns out to boot and run Red Hat 4.1 just fine (using qemu -cpu
> 486 and the no387 option) once I changed /dev/hda1 to /dev/sda1.

Ok. It sounds like the code actually works despite lack of testing,
and it clearly hasn't been the same kind of maintenance pain and
problem that the lack of cmpxchg and friends, so let's leave it alone.
Thanks,

                Linus
