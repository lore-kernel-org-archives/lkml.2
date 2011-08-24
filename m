Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1HXWyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:54:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab1HXWyU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:54:20 -0400
MIME-Version: 1.0
In-Reply-To: <4E555AD0.3020101@goop.org>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
 <1314209019.6925.53.camel@twins> <CA+55aFwuz14ez9=2wiG-344ua0tAJNL8ZuCC41fm6aFgCp+Txw@mail.gmail.com>
 <4E555AD0.3020101@goop.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Aug 2011 15:53:25 -0700
Message-ID: <CA+55aFwp6EM1rwP9k8RCj_M5bzPCkR1N1d9a-VZmYaZNyCNC=A@mail.gmail.com>
Subject: Re: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 1:10 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> Could we just kill SMP support for OOSTORE machines now?  That would be
> the cleanest possible fix...

No it wouldn't. The asm version would *still* be cleaner than the "C
plus random barriers".

It's not like the C version is "portable" in any case.

                         Linus
