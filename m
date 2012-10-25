Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935947Ab2JYQzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:55:03 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47766 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975Ab2JYQzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:55:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6876"; a="1836819"
Date: Thu, 25 Oct 2012 11:54:40 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
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
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: new execve/kernel_thread design
Message-ID: <20121025165440.GB6209@codeaurora.org>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016223508.GR2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 11:35:08PM +0100, Al Viro wrote:
> Maintainers are Cc'd.  My (very, _very_ tentative) patchsets are in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal arch-$ARCH
> 
> Nearly in the same state: ia64.  The only difference is that I've tested
> it under ski(1) and it seems to work.  Accuracy of ski(1) for the purposes
> of finding bugs in asm glue is not inspiring, though.
> 
> Not even a tentative patchset: hexagon, openrisc, tile, xtensa.
> 
> I would very much appreciate ACKs/testing/fixes/outright replacements/etc.
> for this stuff.  Right now all infrastructure is in the mainline and
> per-architecture bits are entirely independent from each other.  As soon
> as maintainer in question is OK with what's in such per-architecture branch,
> I'll be quite happy to put it into never-rebased mode, so that it would be
> safe to pull.  There are some fun things that'll become possible once
> all architectures are converted, but let's handle that stuff first, OK?

Latest version of the Hexagon patches look good.  Thanks!

Acked-by:  Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
