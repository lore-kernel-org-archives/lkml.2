Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1G3GDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 02:03:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab1G3GDy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 02:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E3320A2.1040808@pobox.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com> <4E3320A2.1040808@pobox.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Jul 2011 23:03:24 -0700
Message-ID: <CA+55aFwazvdePdf4ieooQH60bz69v0HNuH4g3M_9WMUVjtw86Q@mail.gmail.com>
Subject: Re: [RFD] Direct support for the x86 RDRAND instruction
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 2:05 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>
> This does not cover the one question I [predictably] have:  why not do this
> in rngd, rather than the kernel?

So that's a silly question. It's a dichotomy that just doesn't exist.
Go ahead and use rdrand in rngd too.

But that is entirely independent of the kernel. Why should any
potential rngd use suddenly mean that the kernel shouldn't try to
improve *its* random number code?

No reason what-so-ever. rngd can do whatever the hell it wants. The
kernel doesn't care, and the kernel isn't impacted. There really is no
reason to do "either or", and they have nothing to do with each other.

The kernel also uses the "mov" instruction too to move data between
registers. Should that mean that user programs shouldn't use that
instruction? Obviously not.

               Linus
