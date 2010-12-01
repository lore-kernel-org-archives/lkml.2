Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0LATaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:30:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab0LATaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:30:04 -0500
Date: Wed, 1 Dec 2010 11:28:56 -0800
From: Greg KH <gregkh@suse.de>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
Message-ID: <20101201192856.GA731@suse.de>
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>
 <4CF5DD63.40803@codeaurora.org>
 <1291229696.14404.39.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291229696.14404.39.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 10:54:56AM -0800, Daniel Walker wrote:
> On Tue, 2010-11-30 at 21:30 -0800, Stephen Boyd wrote:
> > On 11/30/2010 11:25 AM, Daniel Walker wrote:
> > > @@ -682,6 +682,15 @@ config HVC_UDBG
> > >         select HVC_DRIVER
> > >         default n
> > >  
> > > +config HVC_DCC
> > > +       bool "ARM JTAG DCC console"
> > > +       depends on ARM
> > > +       select HVC_DRIVER
> > > +       help
> > > +         This console uses the JTAG DCC on ARM to create a console under the HVC
> > 
> > Looks like you added one too many spaces for indent here.
> 
> The first line is fine, but the other two might need an extra space.

For this, or any other changes you want, I'll gladly take a follow-on
patch as this one is already in my tty-next tree.

thanks,

greg k-h
