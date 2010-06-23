Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0FWW1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:27:34 -0400
Received: from kroah.org ([198.145.64.141]:37732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab0FWW1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:27:33 -0400
Date: Wed, 23 Jun 2010 15:12:53 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: tty: fix switching consoles during suspend
Message-ID: <20100623221253.GA31248@kroah.com>
References: <201006231035.22131.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006231035.22131.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 10:35:21AM +0200, Arnd Bergmann wrote:
> vt_waitactive now expects to be called with the big tty mutex, which
> it tries to release before going to sleep.
> 
> This fixes the only caller that does not hold the BTM already.
> ---
> 
> Greg, please apply to the tty series or fold into
> "tty: introduce wait_event_interruptible_tty", which introduces
> the problem.

Now folded in and pushed out.

thanks,

greg k-h
