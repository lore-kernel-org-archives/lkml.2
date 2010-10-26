Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849Ab0JZQfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:35:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37489 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0JZQfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:35:04 -0400
Message-ID: <4CC702EB.1000301@zytor.com>
Date: Tue, 26 Oct 2010 09:33:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@novell.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h numbers
 in brackets
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com> <20101025140218.5092.74117.stgit@warthog.procyon.org.uk> <28707.1288018465@redhat.com> <4CC5B8D3020000780001EFB4@vpn.id2.novell.com> <AANLkTi=mpKRQgZp5zCoCsBtkuWHrpkOq2Zch-OOGu4CC@mail.gmail.com> <4CC5A748.6050903@zytor.com> <AANLkTik1HB-P0x0e8ucHz7323F-_qAzkaHrHy1Yq4qwo@mail.gmail.com> <4CC5B246.5070909@zytor.com> <alpine.LFD.2.00.1010261126590.15889@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1010261126590.15889@eddie.linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 03:53 AM, Maciej W. Rozycki wrote:
> 
>  Also note that *.*.9x versions are snapshots from the FSF repository (so 
> there's no fixed date associated with them), which also delegates 
> maintenance responsibility to whoever packages them and makes available to 
> people.  In the state as imported from the repository they may have odd 
> problems or grave bugs, as exhaustive regression testing is generally only 
> made after a release branch has been created and otherwise changes to the 
> head of the tree are only tested for a limited subset of targets before 
> they are applied.  Therefore local fixes are inevitable for them anyway.
> 

Well, sort of... the x.x.9x releases used in production -- specifically
the ones with a numbering scheme like x.x.9x.0.x -- in the Linux world
tend to be the ones maintained and released by H.J. Lu:

http://www.kernel.org/pub/linux/devel/binutils/

>  And last but not least binutils are one of the easier tools to build from 
> sources, so installing a newer version, especially when it comes to native 
> tools (hardly anyone uses cross-compilation targeting x86, I believe), 
> somewhere under $HOME to use for kernel builds is a trivial effort:
> 
> $ ./configure --prefix=$HOME/somewhere && make && make install
> $ PATH=$HOME/somewhere/bin:$PATH
> 
> Certainly much easier than building the kernel, especially when it comes 
> to selecting the right configuration options.

Yes, although there is also a version dependency between binutils and
gcc, as I unhappily found out trying to run an upversion gcc on an old
distro at one point.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

