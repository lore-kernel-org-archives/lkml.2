Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab2FAUqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:46:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43871 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab2FAUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:46:32 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20120601213844.3abdae5e@bob.linux.org.uk>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338456918.2760.1318.camel@edumazet-glaptop>
	 <1338574627.2760.1545.camel@edumazet-glaptop>
	 <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	 <20120601213844.3abdae5e@bob.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jun 2012 22:46:27 +0200
Message-ID: <1338583587.2760.1650.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 21:38 +0100, Alan Cox wrote:

> Might be worth checking tty->magic in queue_release_one_tty and the
> entry to release_one_tty
> 
> You can also turn on TTY_PARANOIA_CHECK defines which may show more but
> can also be mistriggered in a few cases.
> 
> What distro setup is this and is it booting to run level 3 or 5. I'm
> just wondering which paths you hit. Some of the distros do weird stuff
> (notably Fedora is totally broken on the console management) and that
> might be hiding a race or two in saner cases where you get more console
> hangups.

Thanks I'll try this.

Distro is Ubuntu 12.04, up2date...

I believe it claims a run level 2



