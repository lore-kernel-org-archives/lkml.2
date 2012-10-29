Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab2J2Oih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:38:37 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:40363 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758957Ab2J2Oie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:38:34 -0400
Date: Mon, 29 Oct 2012 15:38:23 +0100
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
Message-ID: <20121029153823.2317fdef@mschwide>
In-Reply-To: <20121029132521.GW2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
	<20121026183107.GQ2616@ZenIV.linux.org.uk>
	<20121029085339.0ea11bc6@mschwide>
	<20121029132521.GW2616@ZenIV.linux.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12102914-4966-0000-0000-000003E9DBBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 13:25:21 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Oct 29, 2012 at 08:53:39AM +0100, Martin Schwidefsky wrote:
> 
> > Oops, sorry. I tested this weeks ago but it seems I never wrote a mail to
> > indicate success. The current git kernel works just fine.
> 
> "Current git" being what?  Linus' tree?  linux-next?  signal.git#arch-s390?
> FWIW, the relevant diff against mainline is below, linux-next already
> contains it.

git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal arch-s390

against Linux 3.7-rc3

# uname -a
Linux r3545014 3.7.0-rc3-00002-g95a96a7 #1 SMP Mon Oct 29 15:32:18 CET 2012 s390x s390x s390x GNU/Linux

works as it is. Feel free to add my Acked-By.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

