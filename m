Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965916Ab2JZSbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:31:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53924 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965870Ab2JZSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:31:29 -0400
Date: Fri, 26 Oct 2012 19:31:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
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
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [update] Re: new execve/kernel_thread design
Message-ID: <20121026183107.GQ2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016223508.GR2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	The situation got much better by now.  More than a half of
architectures are done - alpha arm arm64 c6x hexagon ia64 m68k mips openrisc
parisc sparc tile um unicore32 and x86.

	Two more avait ACKs from maintainers - powerpc and s390.  Should work,
AFAICS.

	xtensa - Max was going to repost updated patches; waiting for that
to happen, but essentially it's done and tested.

	microblaze - Michal was debugging kernel_execve side of it the last
time I've heard from him...

	frv, mn10300 - dhowells was going to test those

	sh - Paul Mundt was going to test and send fixes

	avr32, blackfin, cris, h8300, m32r, score - no signs of life from
maintainers.  Folks, please show up and at least test the damn patchsets.
Hell knows, they might even work - unicore32 one did, modulo trivial typo,
to my deep surprise...
