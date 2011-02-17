Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab1BQTvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:51:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1BQTvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:51:17 -0500
Date: Thu, 17 Feb 2011 20:51:15 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] fix Steven's Copyright typos
Message-ID: <20110217195115.GR22310@pengutronix.de>
References: <1295899921-11333-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <alpine.LNX.2.00.1102171642100.2160@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1102171642100.2160@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, Feb 17, 2011 at 04:42:56PM +0100, Jiri Kosina wrote:
> On Mon, 24 Jan 2011, Uwe Kleine-König wrote:
> 
> > OK, the copyright allows you to write a copy, still I think the lawyers
> > prefer the correct spelling.
> > 
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  scripts/kconfig/streamline_config.pl |    2 +-
> >  tools/testing/ktest/ktest.pl         |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> > index fd81fc3..a4fe923 100644
> > --- a/scripts/kconfig/streamline_config.pl
> > +++ b/scripts/kconfig/streamline_config.pl
> > @@ -1,6 +1,6 @@
> >  #!/usr/bin/perl -w
> >  #
> > -# Copywrite 2005-2009 - Steven Rostedt
> > +# Copyright 2005-2009 - Steven Rostedt
> >  # Licensed under the terms of the GNU GPL License version 2
> >  #
> >  #  It's simple enough to figure out how this works.
> > diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> > index e1c62ee..ba7c63a 100755
> > --- a/tools/testing/ktest/ktest.pl
> > +++ b/tools/testing/ktest/ktest.pl
> > @@ -1,6 +1,6 @@
> >  #!/usr/bin/perl -w
> >  #
> > -# Copywrite 2010 - Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
> > +# Copyright 2010 - Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
> >  # Licensed under the terms of the GNU GPL License version 2
> >  #
> 
> I prefer not to fiddle with anything surrounding the Copyright lines 
> without explicit permission of the copyright holder.
the patch is already in tip

Thanks
Uwe


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
