Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0ESPCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:02:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48415 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0ESPCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:02:33 -0400
Message-ID: <4BF3FD4F.1060108@zytor.com>
Date: Wed, 19 May 2010 08:01:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Luca Barbieri <luca@luca-barbieri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [GIT PULL] x86/atomic changes for v2.6.35
References: <20100517224531.GA27400@elte.hu>	<AANLkTinWbueCQZdQgZFDLQPJYieB13orxDGYJzzRpPni@mail.gmail.com>	<4BF3F480.3000902@zytor.com> <20100520003641.00618acb.sfr@canb.auug.org.au>
In-Reply-To: <20100520003641.00618acb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 07:36 AM, Stephen Rothwell wrote:
> Hi,
> 
> On Wed, 19 May 2010 07:24:00 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>> On 05/19/2010 04:46 AM, Geert Uytterhoeven wrote:
>>> <boilerplate>
>>> It's a pity this wasn't raised/resolved between its detection in linux-next and
>>> before it entered mainline...
>>> </boilerplate>
>>
>> As far as your boilerplate is concerned, I think Linus made it clear at
>> the Kernel Summit that is it not the obligation of x86/ARM/PowerPC to
>> slow down to not break the smaller architectures; it's the
>> responsibility of those architecture maintainers to keep up.  Sorry.
> 
> I don't think this reply has anything to do with the sentiments expr
> by Geert above.  My interpretation of his comments is just that it is a
> pity noone noticed the problem while it was only in linux-next and
> reported it widely (like on linux-arch) so something could have been done
> before it all Linus' tree.  There was no suggestion of slowing the pace
> of development.

It was discussed on linux-kernel -- note that there is no breakage for
smaller architectures unless you enable the test directly or via randconfig.

The other part is that generic atomic64_t has been available since
middle of 2009, and was *also* discussed extensively on linux-kernel --
in fact, several of the smaller architectures added support at that
time.  That the breakage occurred because of an inconsequential test
rather than real code is thus really nothing but fortunate.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

