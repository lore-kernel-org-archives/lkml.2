Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2CXXUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 19:20:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42404 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab2CXXUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 19:20:10 -0400
Date: Sat, 24 Mar 2012 23:20:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120324232001.GK6589@ZenIV.linux.org.uk>
References: <4F5BD51B.7030907@nod.at>
 <4F5BDB09.3020407@suse.cz>
 <4F5BE1E6.9000201@nod.at>
 <4F5C861F.2000507@nod.at>
 <4F5DCF39.8080308@nod.at>
 <20120312105312.665d2362@pyramind.ukuu.org.uk>
 <4F5DDAD4.4060504@nod.at>
 <20120312114832.784bb6fe@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312114832.784bb6fe@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:48:32AM +0000, Alan Cox wrote:

> > > It will be. In order to fix the tty locking mess we need to shove a lot
> > > of stuff whose lifetime is the lifetime of the physical port somewhere
> > > else - the tty_port is that structure.
> > >
> > 
> > "It will be" in terms of "not now"? ;-)
> 
> As in, it's the very next step on.

FWIW, uml console in default config is basically "start xterm for each VC".
What do you suggest to do on vhangup() on one of those?
