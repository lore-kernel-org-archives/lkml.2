Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab0HRGse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:48:34 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57002 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0HRGs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:48:28 -0400
Date: Wed, 18 Aug 2010 08:48:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Kukjin Kim <kgene.kim@samsung.com>,
        "'Maxim Levitsky'" <maximlevitsky@gmail.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: undefined reference to `mmc_pm_notify' when selected MMC
	without PM.
Message-ID: <20100818064824.GA12088@merkur.ravnborg.org>
References: <009801cb3adb$6550e400$2ff2ac00$%kim@samsung.com> <20100816051721.GA17903@pengutronix.de> <20100816081239.c5ae02ef.randy.dunlap@oracle.com> <20100818063812.GC16956@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818063812.GC16956@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > or this one from earlier:
> > http://lkml.org/lkml/2010/8/12/207
> 
> If I found your patch on gmane I could answer it with an Ack, on lkml
> and kerneltrap (where I found it) I don't get the Message-Id header.

Hi Uwe.

lkml.org has a nice "forward" feature. Look for [forward]
on the second line just below the RSS image.

The mail I reply to is forwarded from lkml.org in this way.

this has been my way to answer lkml mails in periods where
I have not been subscribed and works well.

	Sam
