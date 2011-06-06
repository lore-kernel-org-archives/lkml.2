Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab1FFIrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:47:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756959Ab1FFIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:47:44 -0400
MIME-Version: 1.0
In-Reply-To: <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu> <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Jun 2011 17:46:41 +0900
Message-ID: <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
To: Andy Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 2:50 AM, Andy Lutomirski <luto@mit.edu> wrote:
> CONFIG_UNSAFE_VSYSCALLS was added in the previous patch as a
> temporary hack to avoid penalizing users who don't build glibc from
> git.

I really hate that name.

Do you have *any* reason to call this "unsafe"?

Seriously. The whole patch series just seems annoying.

                  Linus
