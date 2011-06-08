Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1FHGkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 02:40:21 -0400
Received: from r00tworld.com ([212.85.137.150]:52873 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab1FHGkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 02:40:20 -0400
From: pageexec@freemail.hu
To: Pekka Enberg <penberg@kernel.org>
Date: Wed, 08 Jun 2011 08:19:50 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DEF1486.13256.1B62D2D0@pageexec.freemail.hu>
In-reply-to: <BANLkTikNuPg4nfXMqpffpt+5zZwLM_nSzw@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>, <BANLkTikNuPg4nfXMqpffpt+5zZwLM_nSzw@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 08:20:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Jun 2011 at 8:55, Pekka Enberg wrote:

> On Wed, Jun 8, 2011 at 2:24 AM,  <pageexec@freemail.hu> wrote:
> > to give you an idea:
> > - if a code path executes in 1M or 1K cycles once every hour, then
> >  it's not a fast path, it doesn't matter to anyone whether it runs
> >  1 or 10 cycles faster or not,
> 
> I'm pretty sure people who try to optimize kernel boot times, for
> example, don't agree with you.

let's see, we're talking about 100M or more cycles at least (being
generous here as my kernels here seem to take more on the order of
1G or more cycles). i'm pretty sure they're unable to measure single
cycle (or even 10 or a 100 cycle) improvements as well. but they're
welcome to prove me wrong ;).

