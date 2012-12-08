Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab2LHClH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 21:41:07 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:20443 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab2LHClE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 21:41:04 -0500
Message-ID: <50C2A8BB.4010707@tilera.com>
Date: Fri, 7 Dec 2012 21:40:59 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [update] Re: new execve/kernel_thread design
References: <20121016223508.GR2616@ZenIV.linux.org.uk> <20121026183107.GQ2616@ZenIV.linux.org.uk> <20121207222358.GB4939@ZenIV.linux.org.uk>
In-Reply-To: <20121207222358.GB4939@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/2012 5:23 PM, Al Viro wrote:
> Current situation:
>
> * most of the architectures are OK - alpha arm arm64 c6x frv hexagon ia64 m68k
> microblaze mips openrisc parisc sparc s390 tile um unicore32 x86 xtensa
>
> * powerpc *still* awaits an ACK from maintainers; no reports of any breakage
> on linux-next and seems to be doing fine on my tests.
>
> * sh - still nothing from Paul; I'm going to assume that what we have in
> linux-next is OK
>
> * mn10300 - untested, AFAIK
> * avr32, blackfin, cris, h8300, score - maintainers seem to be MIA
> * m32r - maintainer is not MIA, but I'm not sure if anyone, including
> maintainer, has working m32r test boxen anymore...  Anyway, not a word on
> m32r patches in that pile.
>
> Folks, this is the final warning - I *will* send a pull request on the
> stuff currently in linux-next as soon as the merge window opens.  It had
> been sitting there for a long time by now and you've all been Cc'd on
> that thread all along.

IMHO, Al has done a great job reaching out to the architecture maintainers with this round of changes.  I think it should be a model for any kind of similar tree-wide work.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

