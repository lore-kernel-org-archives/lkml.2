Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0K0Xx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 18:53:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab0K0Xxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 18:53:54 -0500
Date: Sat, 27 Nov 2010 18:53:49 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] TTY: don't allow reopen when ldisc is changing
Message-ID: <20101127235349.GB15818@bombadil.infradead.org>
References: <4CEE93FF.3040507@suse.cz>
 <1290705383-6608-1-git-send-email-jslaby@suse.cz>
 <20101126002840.GL22651@bombadil.infradead.org>
 <4CEF65CA.9020403@suse.cz>
 <20101127025954.GA15818@bombadil.infradead.org>
 <4CF0C65E.2010104@suse.cz>
 <4CF0D2DA.20105@suse.cz>
 <4CF11F8A.1050200@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF11F8A.1050200@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 04:11:06PM +0100, Jiri Slaby wrote:
> Is it fixed with the attached proof-of-concept patch?
> 
> So you need:
> THIS ONE
> TTY: don't allow reopen when ldisc is changing
> TTY: ldisc, fix open flag handling
> Char: TTY, restore tty_ldisc_wait_idle
> 
> The last one is in 2.6.37-rc2 already.

Shoved them all into a build and sent it out for testing, the tester who
was hitting it very frequently reports he hasn't seen it, so I think
you've managed to close the race window, awesome!

I rebooted my laptop continuously and didn't hit the WARN_ON as
well to confirm.

--Kyle
