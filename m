Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab2JSSB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:01:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49086 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2JSSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:01:54 -0400
MIME-Version: 1.0
In-Reply-To: <20121019173029.GO2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
	<20121019154901.GK2616@ZenIV.linux.org.uk>
	<3908561D78D1C84285E8C5FCA982C28F19D57A82@ORSMSX108.amr.corp.intel.com>
	<20121019173029.GO2616@ZenIV.linux.org.uk>
Date: Fri, 19 Oct 2012 11:01:53 -0700
Message-ID: <CA+8MBbLr0NhToVU27aH47GLSqga=FArGcU-GxED2h7txCDTEGQ@mail.gmail.com>
Subject: Re: new execve/kernel_thread design
From: Tony Luck <tony.luck@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linus-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 10:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> IIRC, the lack of comments on function with unusual calling conventions was
> the last remaining issue...

Stylistically other asm functions have huge block header
comments detailing register usage. But typically those
are way more complex. I think your inline comments
work fine here.

-Tony
