Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab2J2Hxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:53:53 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:39573 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab2J2Hxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:53:50 -0400
Date: Mon, 29 Oct 2012 08:53:39 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
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
        Richard Kuo <rkuo@codeaurora.org>, Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [update] Re: new execve/kernel_thread design
Message-ID: <20121029085339.0ea11bc6@mschwide>
In-Reply-To: <20121026183107.GQ2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
	<20121026183107.GQ2616@ZenIV.linux.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12102907-8372-0000-0000-00000428452B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012 19:31:07 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> 	The situation got much better by now.  More than a half of
> architectures are done - alpha arm arm64 c6x hexagon ia64 m68k mips openrisc
> parisc sparc tile um unicore32 and x86.
> 
> 	Two more avait ACKs from maintainers - powerpc and s390.  Should work,
> AFAICS.

Oops, sorry. I tested this weeks ago but it seems I never wrote a mail to
indicate success. The current git kernel works just fine.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

