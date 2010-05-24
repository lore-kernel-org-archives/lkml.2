Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab0EXUVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:21:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53344 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755662Ab0EXUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:21:04 -0400
Date: Mon, 24 May 2010 21:27:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 10/13] tty: untangle locking of wait_until_sent
Message-ID: <20100524212755.5aa26fcd@lxorguk.ukuu.org.uk>
In-Reply-To: <20100524190038.GH1292@ucw.cz>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
	<1273012433-6125-11-git-send-email-arnd@arndb.de>
	<20100505205905.3c87b403@lxorguk.ukuu.org.uk>
	<20100524190038.GH1292@ucw.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010 21:00:38 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > >  net/irda/ircomm/ircomm_tty.c  |    2 +-
> > 
> > Semi-defunct at best
> > 
> > This makes me think that now might be a good time to consign the broken
> > crap to the bitbucket unless someone stands up with hardware and who
> > wants to maintain it.
> 
> ircomm_tty is fairly common hardware, afaict, it is just not used
> often. Main use case would be backup of your phone numbers, afaict.
> It would be good to keep it for once-in-a-blue-moon use...

Fine - send patches. Last time I looked at it I couldn't believe it still
worked and the last box I had with Irda capability exploded (literally)
some years ago.

I don't I've seen an Irda capable phone for a while either.
