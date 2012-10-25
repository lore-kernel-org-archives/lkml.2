Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935752Ab2JYQFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:05:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758453Ab2JYQFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:05:54 -0400
Date: Thu, 25 Oct 2012 18:05:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] [trivial] tty: Fix typo in tty drivers
In-Reply-To: <20121024165921.3dc0f9ee@pyramind.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1210251805380.26510@pobox.suse.cz>
References: <1351088981-24976-1-git-send-email-standby24x7@gmail.com> <20121024165921.3dc0f9ee@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Alan Cox wrote:

> > +++ b/drivers/tty/serial/bfin_uart.c
> > @@ -815,7 +815,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
> >  		lcr = WLS(5);
> >  		break;
> >  	default:
> > -		printk(KERN_ERR "%s: word lengh not supported\n",
> > +		printk(KERN_ERR "%s: word length not supported\n",
> >  			__func__);
> 
> Looks fine me although the bfin_uart one should just be picking a
> suitable bit length and reporting back the one it uses not printing
> errors 8)
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

I have picked this one, thanks.

-- 
Jiri Kosina
SUSE Labs
