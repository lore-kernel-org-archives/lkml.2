Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2ADUwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:52:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab2ADUws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:52:48 -0500
Date: Wed, 4 Jan 2012 12:51:46 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
Message-ID: <20120104205146.GA21430@suse.de>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
 <4F04B7DC.70809@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F04B7DC.70809@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 09:34:36PM +0100, Jiri Slaby wrote:
> On 01/04/2012 09:01 PM, Paul Gortmaker wrote:
> >  rename drivers/tty/{ => serial}/amiserial.c (100%)
> >  rename drivers/tty/{ => serial}/cyclades.c (100%)
> >  rename drivers/tty/{ => serial}/isicom.c (100%)
> >  rename drivers/tty/{ => serial}/moxa.c (100%)
> >  rename drivers/tty/{ => serial}/moxa.h (100%)
> >  rename drivers/tty/{ => serial}/mxser.c (100%)
> >  rename drivers/tty/{ => serial}/mxser.h (100%)
> >  rename drivers/tty/{ => serial}/rocket.c (100%)
> >  rename drivers/tty/{ => serial}/rocket.h (100%)
> >  rename drivers/tty/{ => serial}/rocket_int.h (100%)
> >  rename drivers/tty/{ => serial}/synclink.c (100%)
> >  rename drivers/tty/{ => serial}/synclink_gt.c (100%)
> >  rename drivers/tty/{ => serial}/synclinkmp.c (100%)
> 
> Hmm, tty/serial/* used to be for those using serial-core. And tty/ for
> those who don't. But FWIW I don't mind the change.

Yes, that is what I used when splitting them up, so this patch doesn't
make much sense.

Paul, why do you want these all mixed together?

greg k-h
