Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1IWTJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:09:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1IWTJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:09:04 -0400
Date: Fri, 23 Sep 2011 12:08:40 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <greg@kroah.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
Message-ID: <20110923190840.GA31009@suse.de>
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
 <20110922224653.GB21296@kroah.com>
 <4E7CD560.8010706@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7CD560.8010706@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 08:52:16PM +0200, Jiri Slaby wrote:
> On 09/23/2011 12:46 AM, Greg KH wrote:
> > On Wed, Aug 31, 2011 at 09:24:56PM +0200, Jiri Slaby wrote:
> >> Commit "TTY: serial, move locking in uart_close" moved the lock, but
> >> omitted to update branches which unlock the lock. Now they try to
> >> unlock the lock without holding it.
> >>
> >> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >> ---
> >> If possible, please, merge this into the patch mentioned above (it's
> >> not upstream yet).
> > 
> > I can't do that,
> 
> Hmm, but what is the reason for that? I mean, why do you prefer a kernel
> with broken history with respect to bisection? Per definition -next
> doesn't mind rebases in subtrees. Or is this already in tty-linus branch
> (I cannot check now, obviously)?

Because it is in my tree and I can't rebase it as others depend on it
(linux-next and others.)

sorry,

greg k-h
