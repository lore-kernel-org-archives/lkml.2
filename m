Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2I0SOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:14:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44250 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2I0SOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:14:21 -0400
Date: Thu, 27 Sep 2012 11:14:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, hpa@zytor.com, xemul@parallels.com
Subject: Re: [patch 1/2] tty: pty - Move TIOCPKT handling into pty.c
Message-ID: <20120927181417.GA10536@kroah.com>
References: <20120927165958.287690622@openvz.org>
 <20120927170137.722717394@openvz.org>
 <50648DE7.2060904@suse.cz>
 <20120927173714.GQ6618@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927173714.GQ6618@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 09:37:14PM +0400, Cyrill Gorcunov wrote:
> On Thu, Sep 27, 2012 at 07:33:27PM +0200, Jiri Slaby wrote:
> > 
> > Hi!
> > 
> > This check is not needed as the ioctls are master-only.
> 
> Hi, thanks, Jiri, i'll update (was hurry to provide patches
> so missed this ;)

Don't rush, anything you do here will be for 3.8, not 3.7, it's too late
for that, the tty tree already has lots of changes for 3.7.

So take your time please.

greg k-h
