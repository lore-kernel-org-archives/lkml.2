Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1C1R6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:58:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50258 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab1C1R6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:58:16 -0400
Message-ID: <4D90CC0B.8070105@zytor.com>
Date: Mon, 28 Mar 2011 10:57:31 -0700
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
References: <20110326172204.05e52c10.sfr@canb.auug.org.au> <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz> <20110329004438.d9e755ef.sfr@canb.auug.org.au> <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz> <20110328174542.GW21838@one.firstfloor.org>
In-Reply-To: <20110328174542.GW21838@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 10:45 AM, Andi Kleen wrote:
> On Mon, Mar 28, 2011 at 04:05:14PM +0200, Jiri Kosina wrote:
>> On Tue, 29 Mar 2011, Stephen Rothwell wrote:
>>
>>>> I still have some hardware that uses APM and put a new 2.6 on it time 
>>>> to time, so I can take this driver over if you want to. According to 
>>>> git log it's really low effort anyway :)
>>>
>>> If you want it, its yours :-)
>>
>> Not really fighting for maintaining it actively, but can certainly give it 
>> some care when necessary.
> 
> FWIW
> Since Len plans some larger changes to the idle code 
> (moving everything to cpuidle) active care may be needed soon.
> 
> Effectively it would need a APM cpuidle driver.
> 
> Just that you know what you're signing up for...
> 

Or we phase out the APM effort by only supporting it for poweroff, for
example.

	-hpa

