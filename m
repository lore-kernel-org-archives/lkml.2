Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1C1SZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:25:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42779 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1C1SZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:25:51 -0400
Message-ID: <4D90D255.4060008@zytor.com>
Date: Mon, 28 Mar 2011 11:24:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jiri Kosina <jkosina@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] apm: orphan the driver
References: <20110326172204.05e52c10.sfr@canb.auug.org.au> <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz> <20110329004438.d9e755ef.sfr@canb.auug.org.au> <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz> <20110328174542.GW21838@one.firstfloor.org> <4D90CC0B.8070105@zytor.com> <20110328182123.GX21838@one.firstfloor.org>
In-Reply-To: <20110328182123.GX21838@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 11:21 AM, Andi Kleen wrote:
>> Or we phase out the APM effort by only supporting it for poweroff, for
>> example.
> 
> Phasing out APM idle at least would be reasonable.  resumably even if the old 
> laptops still work they are likely on AC because their batteries have
> long died. So using a bit more power in idle shouldn't be a big
> issue.
> 
> Not sure about suspend, screen saver etc. I suppose those could
> be kept as frozen legacy features. At least until someone else
> wants to redesign those parts too.
> 

Since poweroff applies even to stationary systems, it's probably the
most important bit.  Suspend/resume the second most important.

	-hpa
