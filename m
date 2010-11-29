Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0K2Vsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:48:45 -0500
Received: from kroah.org ([198.145.64.141]:37010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0K2Vso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:48:44 -0500
Date: Mon, 29 Nov 2010 13:48:37 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2 1/2] TTY: don't allow reopen when ldisc is changing
Message-ID: <20101129214837.GB9830@kroah.com>
References: <1291022214-27794-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291022214-27794-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 10:16:53AM +0100, Jiri Slaby wrote:
> There are many WARNINGs like the following reported nowadays:
> WARNING: at drivers/tty/tty_io.c:1331 tty_open+0x2a2/0x49a()
> Hardware name: Latitude E6500
> Modules linked in:
> Pid: 1207, comm: plymouthd Not tainted 2.6.37-rc3-mmotm1123 #3
> Call Trace:
>  [<ffffffff8103b189>] warn_slowpath_common+0x80/0x98
>  [<ffffffff8103b1b6>] warn_slowpath_null+0x15/0x17
>  [<ffffffff8128a3ab>] tty_open+0x2a2/0x49a
>  [<ffffffff810fd53f>] chrdev_open+0x11d/0x146
> ...
> 

Are these two patches also for the .36 kernel?  Kyle, you were seeing
the warnings show up there, right?

thanks,

greg k-h
