Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab1AJFs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 00:48:59 -0500
Received: from kroah.org ([198.145.64.141]:49737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1AJFsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 00:48:55 -0500
Date: Sun, 9 Jan 2011 21:49:47 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warnings after merge of the tty tree
Message-ID: <20110110054947.GA21969@kroah.com>
References: <20101221181158.53f62590.sfr@canb.auug.org.au>
 <20101221194204.GA11611@kroah.com>
 <20110110114959.691c20f1.sfr@canb.auug.org.au>
 <20110110005601.GA19570@kroah.com>
 <20110110125908.4251eb45.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110125908.4251eb45.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 12:59:08PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Sun, 9 Jan 2011 16:56:01 -0800 Greg KH <greg@kroah.com> wrote:
> >
> > Yes, Kay just sent me a patch to fix this, which I will queue up after
> > .38-rc1 is out.
> 
> It is surely a pretty obvious patch, why not just do a quick test and
> send it on to Linus (or at least your tty-current tree)?
> 
> /me gets annoyed by more warnings than necessary - especially when they
> should have never been introduced in the first place.

Sorry, I try to keep patches that were not in -next from getting into
Linus's tree before -rc1, but you are right, this should be fixed.  I'll
forward it on later this week, or bundle it up in the "move tty drivers
around" patch that I have for Linus right after -rc1 is out.

thanks,

greg k-h
