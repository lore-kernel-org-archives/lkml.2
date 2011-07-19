Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab1GSBMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 21:12:50 -0400
Received: from infernal.debian.net ([87.230.26.131]:53427 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab1GSBMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 21:12:48 -0400
X-Greylist: delayed 2258 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jul 2011 21:12:48 EDT
Date: Tue, 19 Jul 2011 02:35:04 +0200
From: Andreas Bombe <aeb@debian.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/6] TTY: serial, remove BTM from wait_until_sent
Message-ID: <20110719003503.GA4138@amos.fritz.box>
References: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310646915-3032-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 02:35:10PM +0200, Jiri Slaby wrote:
> This should also fix the issue Andreas is seeing (BTM in comparison to
> BKL doesn't have any hidden functionality like unlocking during
> sleeping).

I tested the patch series and it does not appear to make a difference
for the internal (16550A) serial ports on my system. Also, I am still
unclear on why it freezes the X display during the timeout period.

The other serial port device I have at hand is a FTDI USB->Dual UART
which appears to not have a timeout at all, but then that shows no
difference whether your patches are applied or not. I don't remember if
it was always that way, at least 2.6.39 also acts identically.

-- 
Andreas Bombe
