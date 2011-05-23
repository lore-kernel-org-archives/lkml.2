Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1EWPYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:24:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364Ab1EWPYl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 08:23:44 -0700
Message-ID: <BANLkTinxLPj-S82axeG6JHvM54hGfMt=9w@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] vDSO time changes for 2.6.40
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 6:31 AM, Andy Lutomirski <luto@mit.edu> wrote:
> [Patch 8/8 is brand-new and optional.  If anyone objects to it,
>  please just drop it for 2.6.40 and I'll fix it for 2.6.41.]

Hmm. I would just put it into 7/8 immediately, and never have the
stupid read-lock loop in the first place.

Or I would just say "the time() system call just isn't that critical,
let's not even bother".

But I'll bow to the x86 people on this. I think the series is ok,

                        Linus
