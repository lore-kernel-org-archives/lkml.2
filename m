Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0EDHvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:51:39 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44889 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756532Ab0EDHvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:51:38 -0400
Date: Tue, 4 May 2010 06:14:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org
Subject: 2.6.34-rc6 regression: pcmcia no longer compiles
Message-ID: <20100504041448.GA2893@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

-rc5 compiled ok with similar config.

Now I get:

  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      drivers/pcmcia/pcmcia_ioctl.o
drivers/pcmcia/pcmcia_ioctl.c: In function 'ds_open':
drivers/pcmcia/pcmcia_ioctl.c:714: error: 'struct <anonymous>' has no member named 'present'
drivers/pcmcia/pcmcia_ioctl.c: In function 'ds_read':
drivers/pcmcia/pcmcia_ioctl.c:773: error: 'struct <anonymous>' has no member named 'dead'
drivers/pcmcia/pcmcia_ioctl.c: In function 'ds_ioctl':
drivers/pcmcia/pcmcia_ioctl.c:841: error: 'struct <anonymous>' has no member named 'dead'
make[2]: *** [drivers/pcmcia/pcmcia_ioctl.o] Error 1
make[1]: *** [drivers/pcmcia] Error 2
make: *** [drivers] Error 2


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
