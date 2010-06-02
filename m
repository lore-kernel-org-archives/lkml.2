Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab0FBXbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:31:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab0FBXbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:31:04 -0400
Date: Wed, 2 Jun 2010 16:10:29 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 00/31] tty: BKL removal
Message-ID: <20100602231029.GA12238@suse.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
 <201006030016.44621.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006030016.44621.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:16:44AM +0200, Arnd Bergmann wrote:
> On Tuesday 01 June 2010 22:52:40 Arnd Bergmann wrote:
> > Hi Greg,
> > 
> > As promised, here is a resend of the patches from
> > both Alan and myself, making the BKL optional
> > in the TTY layer. Please apply to your tty-next
> > tree.
> 
> FWIW, I've documented what I've learned about the BKL (now BTM)
> locking in the tty code, see
> http://kernelnewbies.org/BigKernelLock?action=AttachFile&do=view&target=tty_lock.png
> 
> I hope that helps in the process of killing the BTM itself.

Very cool, thanks for documenting this.  I'll queue up your patches in a
few days.

greg k-h
