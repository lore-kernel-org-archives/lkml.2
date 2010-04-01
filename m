Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0DAPYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:24:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab0DAPXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:23:54 -0400
Date: Thu, 1 Apr 2010 08:24:21 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 0/9] BKL conversion in TTY drivers
Message-ID: <20100401152421.GA12638@suse.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de> <201003310957.03025.arnd@arndb.de> <20100331110228.2443ccd6@lxorguk.ukuu.org.uk> <201004011451.59712.arnd@arndb.de> <20100401151756.5e329014@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401151756.5e329014@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 03:17:56PM +0100, Alan Cox wrote:
> > Greg, are you ok with merging these TTY patches in your tree for 2.6.35
> > then? There will be at least one more respin of it for minor changes
> > and anything that comes up during testing, but it's essentially what I
> > posted here.
> 
> Can we please wait a bit with the tty bits. I'm slowing picking through
> the job properly and there are a lot of low hanging fruit to clean up at
> the driver end of things that is best done before we complicate the core
> stuff.

No problem, I'll wait for your work before picking up any of these bkl
tty patches.

thanks,

greg k-h
