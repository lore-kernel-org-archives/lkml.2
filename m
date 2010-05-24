Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0EXTAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:00:49 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40345 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755611Ab0EXTAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:00:48 -0400
Date: Mon, 24 May 2010 21:00:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 10/13] tty: untangle locking of wait_until_sent
Message-ID: <20100524190038.GH1292@ucw.cz>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
 <1273012433-6125-11-git-send-email-arnd@arndb.de>
 <20100505205905.3c87b403@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505205905.3c87b403@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  net/irda/ircomm/ircomm_tty.c  |    2 +-
> 
> Semi-defunct at best
> 
> This makes me think that now might be a good time to consign the broken
> crap to the bitbucket unless someone stands up with hardware and who
> wants to maintain it.

ircomm_tty is fairly common hardware, afaict, it is just not used
often. Main use case would be backup of your phone numbers, afaict.
It would be good to keep it for once-in-a-blue-moon use...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
