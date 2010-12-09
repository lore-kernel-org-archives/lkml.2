Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0LIVXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:23:46 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:37696 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab0LIVXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:23:45 -0500
Date: Thu, 9 Dec 2010 13:23:40 -0800
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org, Ben Gardner <bgardner@wabtec.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] cs5535: deprecate older cs5535_gpio driver
Message-ID: <20101209132340.291b784b@queued.net>
In-Reply-To: <20101209131337.be92caf6.akpm@linux-foundation.org>
References: <20101209125737.065e91fd@queued.net>
	<20101209131337.be92caf6.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010 13:13:37 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 9 Dec 2010 12:57:37 -0800
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > The newer drivers/gpio/cs5535-gpio.c replaces
> > drivers/misc/cs5535_gpio.c.  The new driver has been in the tree
> > for a little while, and has received some testing; it's time to mark
> > the old one as deprecated.  I'm thinking removal around 2.6.40 would
> > be good, provided we're not missing critical functionality in the
> > newer driver.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > ---
> >  Documentation/feature-removal-schedule.txt |   14 ++
> >  drivers/char/Kconfig                       |    9 -
> >  drivers/char/Makefile                      |    1 -
> >  drivers/char/cs5535_gpio.c                 |  259
> > ----------------------------
> > drivers/staging/Kconfig                    |    2 +
> > drivers/staging/Makefile                   |    1 +
> > drivers/staging/cs5535_gpio/Kconfig        |   11 ++
> > drivers/staging/cs5535_gpio/Makefile       |    1 +
> > drivers/staging/cs5535_gpio/TODO           |    6 +
> > drivers/staging/cs5535_gpio/cs5535_gpio.c  |  259
> > ++++++++++++++++++++++++++++ 10 files changed, 294 insertions(+),
> > 269 deletions(-) delete mode 100644 drivers/char/cs5535_gpio.c
> > create mode 100644 drivers/staging/cs5535_gpio/Kconfig create mode
> > 100644 drivers/staging/cs5535_gpio/Makefile create mode 100644
> > drivers/staging/cs5535_gpio/TODO create mode 100644
> > drivers/staging/cs5535_gpio/cs5535_gpio.c
> 
> It seems logical (although not particularly useful) to use
> drivers/staging/ as the site for unstaging things as well, but is that
> something which we normally do?
> 

FYI, I was using commits 7af97eff and 96322b80 as an example... Though
I suppose I really should've chosen commits by two separate authors
(oops).

