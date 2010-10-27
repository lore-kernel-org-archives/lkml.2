Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab0J0Aus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:50:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60102 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab0J0Auq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:50:46 -0400
Date: Wed, 27 Oct 2010 01:50:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, "Dr. Werner Fink" <werner@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
Message-ID: <20101027005045.GC19804@ZenIV.linux.org.uk>
References: <20101022175112.GC13489@kroah.com>
 <1287771688-14805-28-git-send-email-gregkh@suse.de>
 <4CC2C9A8.1040003@suse.cz>
 <20101025075125.GA29179@boole.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025075125.GA29179@boole.suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 09:51:25AM +0200, Dr. Werner Fink wrote:
> > Maybe I wouldn't bother with marking the "current" console by star at
> > all as it seems not to pay off.
> 
> This is the main reason for what I've done this patch:
> To see on which console line the reading process is
> located. Please do not skip this part as this is
> currently the only way to detect the real console below
> /dev/console ... it could be used in user space: e.g. in
> plymouth or bootlogd (to deterime the main console) or
> sulogin (to be able to provide a prompt on all console
> lines).

You've got to be kidding.  So all this stuff is about getting TIOCGDEV
into the mainline?  In a form that would, presumably, be more acceptable
than an ioctl?

> -- 
>   "Having a smoking section in a restaurant is like having
>           a peeing section in a swimming pool." -- Edward Burr

Ironic, innit?
