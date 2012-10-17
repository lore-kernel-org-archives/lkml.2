Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2JQOHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:07:06 -0400
Received: from mail.southpole.se ([193.12.106.18]:59622 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2JQOHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <20121016223508.GR2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
Date: Wed, 17 Oct 2012 16:07:00 +0200
Message-ID: <CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
Subject: Re: new execve/kernel_thread design
From: Jonas Bonn <jonas@southpole.se>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linus-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 82821-04587
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2012 00:35, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Not even a tentative patchset: hexagon, openrisc, tile, xtensa.
>

I did most of the OpenRISC conversion last weekend... the
kernel_thread bits work fine but I end up with the init thread dying
with what I've got now for kernel_execve.  Once I've got that sorted
out, I'll pass this along to you.

Thanks for the above explanation... it took me a good while to wrap my
head around how this was supposed to work from reading through the
arch's that you had already converted.  All in all, though, I find
it's a nice cleanup and, conceptually, an improvement over what we had
before.

Thanks,
Jonas
