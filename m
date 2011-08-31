Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1HaTlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:41:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50272 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab1HaTlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:41:45 -0400
X-Sasl-enc: XgGucrEfixwRN+14v5DDyS+f6Z7aIPL7k+K98F7mQMJO 1314819704
Date: Wed, 31 Aug 2011 12:41:31 -0700
From: Greg KH <greg@kroah.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alan Cox <alan@linux.intel.com>, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 4/4] TTY: serial, move 68360 driver to staging
Message-ID: <20110831194131.GB14091@kroah.com>
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
 <1314818699-10873-4-git-send-email-jslaby@suse.cz>
 <1314819086.30506.3.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314819086.30506.3.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 10:31:26PM +0300, Sasha Levin wrote:
> On Wed, 2011-08-31 at 21:24 +0200, Jiri Slaby wrote:
> > This driver has been broken at least since 2008. At that time,
> > a88487c79b (Fix compile errors in SGI console drivers) broke this
> > driver completely.
> > 
> > And since nobody noticed for the past 3 years, move it into staging. I
> > think this will rot there and we will throw it away completely after
> > some time. Or maybe someone will volunteer to fix it ;).
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Alan Cox <alan@linux.intel.com>
> > ---
> > Cc: linux-m68k@lists.linux-m68k.org
> >  drivers/staging/Kconfig              |    2 +
> >  drivers/staging/Makefile             |    1 +
> >  drivers/staging/serial/68360serial.c | 2979 ++++++++++++++++++++++++++++++++++
> >  drivers/staging/serial/Kconfig       |   16 +
> >  drivers/staging/serial/Makefile      |    1 +
> >  drivers/staging/serial/TODO          |    6 +
> >  drivers/tty/serial/68360serial.c     | 2979 ----------------------------------
> >  drivers/tty/serial/Kconfig           |   17 -
> >  drivers/tty/serial/Makefile          |    1 -
> >  9 files changed, 3005 insertions(+), 2997 deletions(-)
> >  create mode 100644 drivers/staging/serial/68360serial.c
> >  create mode 100644 drivers/staging/serial/Kconfig
> >  create mode 100644 drivers/staging/serial/Makefile
> >  create mode 100644 drivers/staging/serial/TODO
> >  delete mode 100644 drivers/tty/serial/68360serial.c
> 
> 'git mv' and 'git format-patch --find-renames' would make this patch so
> much nicer.

That will happen automatically when I apply the patch, so don't worry
about it.

greg k-h
