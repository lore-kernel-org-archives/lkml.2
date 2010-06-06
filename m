Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0FFJoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:44:13 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38647 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0FFJoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:44:12 -0400
Date: Sun, 6 Jun 2010 11:44:07 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Ruud Linders <kernelml@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial/ftdi_sio: fix DTR/RTS line modes
Message-ID: <20100606094407.GN2695@buzzloop.caiaq.de>
References: <1275566102-5613-1-git-send-email-daniel@caiaq.de>
 <20100603115727.GY2695@buzzloop.caiaq.de>
 <4C0B6B52.5050702@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0B6B52.5050702@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 11:33:06AM +0200, Ruud Linders wrote:
> Hmm, I tried this patch on plain 2.6.34 but still have a problem.
> As you indicated since 2.6.31-something something is broken.
> 
> I'm using a receive only device (http://rfxcom.com/receivers.htm)
> which works fine until the system becomes more busy, usually it runs
> almost idle and all is fine.
> 
> However, when this happens, it appears the received characters get
> buffered somewhere as nothing seems to get through or is delayed for
> many minutes.
> When I then =write= a character to the serial device
> 	echo > /dev/ttyUSB0
> the data is received in sudden burst, seems no data is actually lost
> just seriously delayed.
> 
> Any ideas ?

Hmm, no, sorry. Things work fine for me again now.

Did you try reverting the commit I blamed in the commit log? If this
doesn't help, I can only suggest you run a bisect to see which commit
between 2.6.31 and 2.6.34 broke it for you.

Daniel

