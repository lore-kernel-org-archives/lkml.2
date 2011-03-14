Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1CNQdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:33:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43743 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab1CNQdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:33:32 -0400
Message-ID: <4D7E4338.1060302@zytor.com>
Date: Mon, 14 Mar 2011 09:32:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: sedat.dilek@gmail.com, Alan Modra <amodra@bigpond.net.au>,
        Ingo Molnar <mingo@elte.hu>, "H.J. Lu" <hjl.tools@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: Add --size-check=[error|warning]
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com> <4D7E095802000078000363D5@vpn.id2.novell.com>
In-Reply-To: <4D7E095802000078000363D5@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 04:26 AM, Jan Beulich wrote:
> 
> Making the kernel build system check for certain newly introduced
> gas options would again require changes to the kernel sources,
> which is precisely what is impossible to do for past kernel releases
> (and bisection in particular).
> 

But something like "make CC='gcc -Wa,--size-check=warning'" should work,
I believe (tweaking may be required, but that's the idea).  Passing an
option to the assembler is a helluva lot easier than redirecting to a
different assembler.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

