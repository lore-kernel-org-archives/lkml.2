Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab0FBJrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:47:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50031 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757705Ab0FBJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:47:35 -0400
Date: Wed, 2 Jun 2010 10:47:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: sonic zhang <sonic.adi@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] regulator: new drivers for
 AD5398 and AD5821
Message-ID: <20100602094733.GA13983@rakim.wolfsonmicro.main>
References: <1275468694.2545.1.camel@eight.analog.com>
 <AANLkTinaPmKUx04I1mjNhla4s3S6vmWp8x6eoDTZGRVz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinaPmKUx04I1mjNhla4s3S6vmWp8x6eoDTZGRVz@mail.gmail.com>
X-Cookie: //GO.SYSIN DD *, DOODAH, DOODAH
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 05:02:58AM -0400, Mike Frysinger wrote:

> > +       dev_dbg(&client->dev, "%s regulator driver loaded\n", id->name);

> does the regulator core take care of displaying a notice ?  if not,
> i'd make this dev_info().  also, this should be "registered", not
> "loaded".

A message will be displayed if the device actually has any constraints
(and is therefore in use) so if it makes any difference to the system
there will be some chat.

> > +MODULE_DESCRIPTION("AD5398 and AD5821 current regulator driver");
> > +MODULE_AUTHOR("Sonic Zhang");
> > +MODULE_LICENSE("GPL");

> should there be a MODULE_ALIAS() ?

Possibly, though it's unlikely that actual systems will ever build a
regulator they're using as a module.
