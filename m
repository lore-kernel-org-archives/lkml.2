Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1CNSCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:02:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53928 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab1CNSCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:02:47 -0400
Message-ID: <4D7E580A.6000807@zytor.com>
Date: Mon, 14 Mar 2011 11:01:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ian Lance Taylor <iant@google.com>
CC: Jan Beulich <JBeulich@novell.com>, sedat.dilek@gmail.com,
        Ingo Molnar <mingo@elte.hu>, amodra@gmail.com,
        "H.J. Lu" <hjl.tools@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: Add --size-check=[error|warning]
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>	<4D7E095802000078000363D5@vpn.id2.novell.com>	<AANLkTikUKE4xzf-NJtK3vMCQmNEYiAXZzi2vMZs9Zy4W@mail.gmail.com>	<AANLkTimmi7A6cXo8BCHWtBDmauZD4_-dNjThpn1J9DkW@mail.gmail.com>	<4D7E166C0200007800036451@vpn.id2.novell.com> <mcrtyf53dci.fsf@google.com>
In-Reply-To: <mcrtyf53dci.fsf@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 08:56 AM, Ian Lance Taylor wrote:
> "Jan Beulich" <JBeulich@novell.com> writes:
> 
>> No - $(AS) isn't being used to translate .S files, $(CC) is being used
>> instead. That's why I pointed at the necessary -B option (so that
>> the compiler would be able to locate the wrapper H.J. suggested).
> 
> You could also just put a -Wa option in your $(CC).  That seems simpler
> than a -B option.
> 
> (I don't really care about this issue one way or another.)
> 

-Wa is definitely the sane way to do it.  The -B thing came in if you
have to run a patched version of as, which is extremely painful.

	-hpa

