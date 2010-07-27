Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0G0ADK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:03:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab0G0ADI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:03:08 -0400
Date: Mon, 26 Jul 2010 17:01:44 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Jensen <emjay1988@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev: Removed unused macro
 definitions
Message-ID: <20100727000143.GA26992@suse.de>
References: <1280070874-8961-1-git-send-email-emjay1988@gmail.com>
 <20100726224301.GA5287@kroah.com>
 <AANLkTikmDu+sOfNFwCJmshyKmeF5B1sZg6r+5_0qKc_8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikmDu+sOfNFwCJmshyKmeF5B1sZg6r+5_0qKc_8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 09:46:00AM +1000, Michael Jensen wrote:
> On Tue, Jul 27, 2010 at 8:43 AM, Greg KH <greg@kroah.com> wrote:
> >
> > This doesn't apply against the linux-next tree as this macro is already
> > gone from there.
> >
> > What tree are you creating this diff against?
> >
> > confused,
> >
> > greg k-h
> >
> 
> The main tree, cloned from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Yeah, that's not going to work for any development.

Try the linux-next tree instead, that is where everything is queuing up.
Again, this macro is already gone in the linux-next tree which is what
will be merged with Linus's tree for the next release (2.6.36).

Hope this helps,

greg k-h
