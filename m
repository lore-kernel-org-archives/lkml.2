Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1FOQid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:38:33 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38483 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751093Ab1FOQic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:38:32 -0400
Date: Wed, 15 Jun 2011 17:37:53 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wanlong Gao <wanlong.gao@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.0-rc3
Message-ID: <20110615163753.GA15155@linux-mips.org>
References: <1308138281.4112.3.camel@Tux>
 <20110615222932.05a863fc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615222932.05a863fc.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:29:32PM +1000, Stephen Rothwell wrote:

> On Wed, 15 Jun 2011 19:44:41 +0800 Wanlong Gao <wanlong.gao@gmail.com> wrote:
> >
> > <snip>
> > I see that some mips fixes in ralf's tree but not been pulled. almost
> > for about one month.
> 
> Well, the mips tree in linux-next is
> git://git.linux-mips.org/pub/scm/upstream-sfr.git#mips-for-linux-next and
> I fetch it every day.

I only have the new bits in linux-next but not the pending for the current
work-in-progress kernel, that is 3.0.  Those are queued in

http://git.linux-mips.org/?p=upstream-linus.git;a=summary
git://git.linux-mips.org/pub/scm/upstream-linus.git

and I've sent two pull requests to Linus so far which went without
reaction ...

  Ralf
