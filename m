Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2JSSd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:33:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35278 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab2JSSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:33:55 -0400
Date: Fri, 19 Oct 2012 19:33:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tony Luck <tony.luck@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: new execve/kernel_thread design
Message-ID: <20121019183347.GQ2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <20121019154901.GK2616@ZenIV.linux.org.uk>
 <3908561D78D1C84285E8C5FCA982C28F19D57A82@ORSMSX108.amr.corp.intel.com>
 <20121019173029.GO2616@ZenIV.linux.org.uk>
 <CA+8MBbLr0NhToVU27aH47GLSqga=FArGcU-GxED2h7txCDTEGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbLr0NhToVU27aH47GLSqga=FArGcU-GxED2h7txCDTEGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 11:01:53AM -0700, Tony Luck wrote:
> On Fri, Oct 19, 2012 at 10:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > IIRC, the lack of comments on function with unusual calling conventions was
> > the last remaining issue...
> 
> Stylistically other asm functions have huge block header
> comments detailing register usage. But typically those
> are way more complex. I think your inline comments
> work fine here.

Thanks; ACKed-by and Tested-by added, branch put into no-rebase mode.
So openrisc and ia64 are in the finished pile now...
