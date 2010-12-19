Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab0LSQ5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 11:57:07 -0500
Received: from 1wt.eu ([62.212.114.60]:48755 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0LSQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 11:57:05 -0500
Date: Sun, 19 Dec 2010 17:56:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [ANNOUNCE] Linux 2.6.35.10 has been released
Message-ID: <20101219165653.GK26410@1wt.eu>
References: <20101214232747.GA18757@basil.fritz.box> <877hf66929.fsf@depni.sinp.msu.ru> <20101219002146.GA11568@kroah.com> <20101219103609.GB28751@basil.fritz.box> <20101219163935.GA23359@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101219163935.GA23359@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 08:39:35AM -0800, Greg KH wrote:
> On Sun, Dec 19, 2010 at 11:36:10AM +0100, Andi Kleen wrote:
> > On Sat, Dec 18, 2010 at 04:21:46PM -0800, Greg KH wrote:
> > > > Could you please update this tree:
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git ?
> > > 
> > > No, the "stable" trees are not being updated anymore, they have moved to
> > > the longterm git directory instead.
> > 
> > It would be good if the old stable git tree for 2.6.35 was deleted to avoid
> > confusion. Greg, what do you think?
> 
> No, we have never deleted any of the other trees when we "stopped"
> maintaining them, so we shouldn't delete these either.
> 
> I need to look this week at using git notes to mark trees as unsupported
> or supported in a way that will work well.  That should solve this issue
> as the note could also say 'go look at the longterm kernel' as well.

Once again, I think it's not too late to replace the old trees with a
symlink to the new one (or the opposite), considering that users have
not updated their scripts yet. Also I'm realizing it's a bit bothering
as a user to have to change the address of the remote when tracking such
a branch.

Regards,
Willy

