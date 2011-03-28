Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1C1SrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:47:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab1C1SrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:47:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110328182123.GX21838@one.firstfloor.org>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au> <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz>
 <20110329004438.d9e755ef.sfr@canb.auug.org.au> <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz>
 <20110328174542.GW21838@one.firstfloor.org> <4D90CC0B.8070105@zytor.com> <20110328182123.GX21838@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Mar 2011 11:46:18 -0700
Message-ID: <AANLkTimqE2YZCH5GonnqeHGGBwzggTymauS1KYuTsqOX@mail.gmail.com>
Subject: Re: [PATCH] apm: orphan the driver
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ondrej Zary <linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:21 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Phasing out APM idle at least would be reasonable.  resumably even if the old
> laptops still work they are likely on AC because their batteries have
> long died. So using a bit more power in idle shouldn't be a big
> issue.

Agreed. Especially since I'm not at all convinced that APM CPU idling
ever really worked in the first place.

And as you say, it's not a catastrophic failure even if we were to
remove it, and even if it were to have mattered on those old laptops
years ago. I think we can happily say "not worth worrying about" when
it comes to APM_CPU_IDLE.

And shutdown, suspend and screensaver should all be much easier to
continue to support - they shouldn't have any serious infrastructure
issues.

                       Linus
