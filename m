Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab1BQUCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:02:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab1BQUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:02:06 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=ctxceuTV3N8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=V3qLwo6i9-Oo1h7wbRcA:9 a=8l2IuvACx5PbhtWKhUwA:7 a=sgWVnwcATYQnGqQAcrFYwmHRIV4A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=XNN-oNMjSfgA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] fix Steven's Copyright typos
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1102171642100.2160@pobox.suse.cz>
References: <1295899921-11333-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <alpine.LNX.2.00.1102171642100.2160@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Feb 2011 15:02:02 -0500
Message-ID: <1297972922.23343.945.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 16:42 +0100, Jiri Kosina wrote:
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
> 
> Steven? :)

Hi Jiri,

Thanks for the concern, but I'm the one that pulled them in. And I
talked with Uwe about this on IRC before hand.

-- Steve


