Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0EEXrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:47:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48141 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752528Ab0EEXrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:47:31 -0400
Date: Thu, 6 May 2010 00:52:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 10/13] tty: untangle locking of wait_until_sent
Message-ID: <20100506005226.62b41736@lxorguk.ukuu.org.uk>
In-Reply-To: <20100505225139.GA19163@suse.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
	<1273012433-6125-11-git-send-email-arnd@arndb.de>
	<20100505205905.3c87b403@lxorguk.ukuu.org.uk>
	<20100505225139.GA19163@suse.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, which ones should I move?  How about to start with the ones you
> listed above:
> 	drivers/char/amiserial.c
> 	drivers/char/generic_serial.c

Generic serial covers several old drivers that are defunct
	drivers/char/rio/
	drivers/char/vme_scc
	drivers/char/ser_a2232
	drivers/char/sx/
	drivers/char/ip2/

> 	drivers/char/specialix.c

Leave specialix.c for now - that one is probably salvagable fairly easily
and I think has a couple of users.

