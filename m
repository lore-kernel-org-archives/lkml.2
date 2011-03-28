Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1C1SV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:21:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47606 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1C1SVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:21:24 -0400
Date: Mon, 28 Mar 2011 20:21:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] apm: orphan the driver
Message-ID: <20110328182123.GX21838@one.firstfloor.org>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au> <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz> <20110329004438.d9e755ef.sfr@canb.auug.org.au> <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz> <20110328174542.GW21838@one.firstfloor.org> <4D90CC0B.8070105@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D90CC0B.8070105@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Or we phase out the APM effort by only supporting it for poweroff, for
> example.

Phasing out APM idle at least would be reasonable.  resumably even if the old 
laptops still work they are likely on AC because their batteries have
long died. So using a bit more power in idle shouldn't be a big
issue.

Not sure about suspend, screen saver etc. I suppose those could
be kept as frozen legacy features. At least until someone else
wants to redesign those parts too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
