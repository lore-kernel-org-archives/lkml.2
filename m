Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0K2Wcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:32:45 -0500
Received: from kroah.org ([198.145.64.141]:49264 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab0K2Wco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:32:44 -0500
Date: Mon, 29 Nov 2010 14:32:29 -0800
From: Greg KH <greg@kroah.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2 1/2] TTY: don't allow reopen when ldisc is changing
Message-ID: <20101129223229.GC14663@kroah.com>
References: <1291022214-27794-1-git-send-email-jslaby@suse.cz>
 <20101129214837.GB9830@kroah.com>
 <20101129222342.GL15818@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129222342.GL15818@bombadil.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 05:23:42PM -0500, Kyle McMartin wrote:
> On Mon, Nov 29, 2010 at 01:48:37PM -0800, Greg KH wrote:
> > >  [<ffffffff8103b189>] warn_slowpath_common+0x80/0x98
> > >  [<ffffffff8103b1b6>] warn_slowpath_null+0x15/0x17
> > >  [<ffffffff8128a3ab>] tty_open+0x2a2/0x49a
> > >  [<ffffffff810fd53f>] chrdev_open+0x11d/0x146
> > 
> > Are these two patches also for the .36 kernel?  Kyle, you were seeing
> > the warnings show up there, right?
> > 
> 
> Yup, I guess they turned up when the BKL went away. (I reverted the BKL
> removal patches on top of 2.6.36, and never saw this WARN_ON trigger at
> least.)

Ok, thanks, that helps.

greg k-h
