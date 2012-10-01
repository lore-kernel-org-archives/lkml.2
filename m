Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2JAWNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:13:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46262 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055Ab2JAWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:13:52 -0400
X-Sasl-enc: p9OPVcrZi1I70dDIx7+JULVYBLzyeoutnP/jmZCktSfO 1349129631
Date: Mon, 1 Oct 2012 15:13:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>, Stanislav Kozina <skozina@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Stanislav Kozina <skozina@redhat.com>
Subject: Re: [GIT PATCH] TTY patches for 3.7-rc1
Message-ID: <20121001221350.GA10172@kroah.com>
References: <20121001183046.GA13042@kroah.com>
 <506A0FCA.2020908@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506A0FCA.2020908@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 11:48:58PM +0200, Jiri Slaby wrote:
> On 10/01/2012 08:30 PM, Greg KH wrote:
> > Stanislav Kozina (2):
> >       tty: Fix possible race in n_tty_read()
> 
> The (pretty hopeless) commit log says:
>     Fix possible panic caused by unlocked access to tty->read_cnt in
>     while-loop condition in n_tty_read().
> 
> Just curious, what kind of panic that can cause, can you be more
> concrete on that? I suppose two readers, one eats everything, the other
> is a killer? And should we backport to -stable?

Stanislav, you are the one who could reproduce this, any answers here?

thanks,

greg k-h
