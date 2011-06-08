Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1FHKGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:06:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35226 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1FHKGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:06:16 -0400
Date: Wed, 8 Jun 2011 12:06:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: pageexec@freemail.hu
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110608100612.GJ27166@one.firstfloor.org>
References: <20110608091120.GI27166@one.firstfloor.org> <4DEF424F.2351.1C15AD40@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEF424F.2351.1C15AD40@pageexec.freemail.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> eventually may even go away as time progresses and
> linux systems begin to fully rely on the vdso instead.

That assumes that everyone uses glibc and also updates their userland. 
As pointed out many times that's a deeply flawed assumption.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
