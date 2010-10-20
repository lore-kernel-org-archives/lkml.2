Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0JTWkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:40:11 -0400
Received: from kroah.org ([198.145.64.141]:57404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab0JTWj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:39:56 -0400
Date: Wed, 20 Oct 2010 15:39:58 -0700
From: Greg KH <greg@kroah.com>
To: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: [B.A.T.M.A.N.] [resend][PATCHv2] staging: batman-adv: remove
	useless addr_to_string()
Message-ID: <20101020223958.GA17011@kroah.com>
References: <1287589664-25447-1-git-send-email-andy.shevchenko@gmail.com> <20101020205115.GA18087@sven-atom.lazhur.ath.cx> <20101020205749.GA9686@kroah.com> <20101020221636.GA21132@sven-atom.lazhur.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020221636.GA21132@sven-atom.lazhur.ath.cx>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 12:16:37AM +0200, Sven Eckelmann wrote:
> On Wed, Oct 20, 2010 at 01:57:49PM -0700, Greg KH wrote:
> > On Wed, Oct 20, 2010 at 10:51:15PM +0200, Sven Eckelmann wrote:
> > > On Wed, Oct 20, 2010 at 06:47:44PM +0300, Andy Shevchenko wrote:
> > > > Since all *printf() methods in the kernel understand '%pM' modifier the
> > > > conversion to the string is useless beforehand.
> > > > 
> > > > Additionally this patch decreases batman_if structure by 20 bytes.
> > > 
> > > Thanks for your patch. I have problems with compiling due to other patches in
> > > the queue. I will fix that and recommend it as patch for 2.6.38.
> > 
> > What do you mean by this?  It applies just fine to my tree, so why can't
> > I take it now?
> 
> If you want then do so, but the stuff in batman-adv's master must be fixed so
> they have to apply the v3 version of the patch and not the v2 version Andy
> sent.

That's one of the problems with having an out-of-tree tree.  Please
don't do that at all anymore.

I'll go apply this patch to mine, and you can handle any merge issues if
you continue to wish to keep an external tree (hint, I STRONGLY
recommend that you do not, for these reasons and many others.)

thanks,

greg k-h
