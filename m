Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1BWSin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:38:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:46921 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab1BWSim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:38:42 -0500
Date: Wed, 23 Feb 2011 10:20:53 -0800
From: Greg KH <gregkh@suse.de>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        Stalin Srinivasan <stalin.s@mistralsolutions.com>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Message-ID: <20110223182053.GB30517@suse.de>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
 <20110218143500.23b3044b@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1102181917520.2701@localhost6.localdomain6>
 <201102181951.32631.arnd@arndb.de>
 <9826735BD9DD48A599C595D28C4A05F0@subhasishg>
 <20110222143704.GA978@suse.de>
 <86364E209B534BF1ADB2764227483070@subhasishg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86364E209B534BF1ADB2764227483070@subhasishg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:00:25AM +0530, Subhasish Ghosh wrote:
> I could not follow the recommendations clearly.
> This is just to clarify.
> 
> Currently, I have the following files for the suart implementation:
> 
> drivers/tty/serial/da8xx_pruss/pruss_suart_api.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_err.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_regs.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_board.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_mcasp.h
> drivers/tty/serial/da8xx_pruss/pruss_suart_utils.h
> 
> drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
> drivers/tty/serial/da8xx_pruss/pruss_suart.c
> drivers/tty/serial/da8xx_pruss/pruss_suart_utils.c
> 
> Of these, I will be removing pruss_suart_err.h as part of the Linux
> error code cleanup.
> But, I need to keep at least  pruss_suart_board.h as a separate
> file, as this defines
> configurations which will be often modified by users, I don't want
> to mix it with other files.

Why would a .h file ever need to be "modified by users"?  That sounds
wrong to me.

> Should I combine rest of the headers into a single file ?

Yes, why would they need to be separate?

> and keep the other three .c files under "drivers/tty/serial/" and
> remove the da8xx_pruss directory altogether.

Yes.

thanks,

greg k-h
