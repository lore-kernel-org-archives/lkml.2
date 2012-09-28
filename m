Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2I1Lec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:34:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2I1Lea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:34:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2] mfd: da9052-core: Use regmap_irq_get_virq() and fix the probe
Date: Fri, 28 Sep 2012 11:34:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com, marex@denx.de,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com> <201209280642.05747.arnd@arndb.de> <CAOMZO5BChG==wddh6Qb0LuShoRKf3VoLppJvY43ifL6Vf1ft0w@mail.gmail.com>
In-Reply-To: <CAOMZO5BChG==wddh6Qb0LuShoRKf3VoLppJvY43ifL6Vf1ft0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209281134.20667.arnd@arndb.de>
X-Provags-ID: V02:K0:UymJrqkaGfvmNJ4AyPZ7oD1RZAEM6I7drNp4Lt5hlB/
 s+X6YodXaCoEdLJg55XIQvhQJXDgBFQGbyTZHmL37L0KgNwcfH
 GM2OHk3XTB+qqN9M1B8OyUwVXkNgDKFiepo3drk7tKtkLIh9/e
 TV1K6McwLYPXIT9cgBJVYbEFOqTHYRpCJ4konIBNhFJGnIeAxM
 AsJESMfPewxMRR9W8ISvU2R9VFS82StC57qSeU5LOwsroqPNdN
 FE4cZkNK6ntU/3UjBGhJvnN6YGEYnRwsia5gcjvRO8YkYZwd/e
 hIpqwl0a9D5Uc1Apv6EeBZ7++9QrtlX8W9DtlZYzSIniGPr3II
 B5a8mNwtRB0FdJOyqdA0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2012, Fabio Estevam wrote:
> On Fri, Sep 28, 2012 at 3:42 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > This looks good.
> >
> >> I also plan to convert the other da9052 drivers to use regmap_irq_get_virq().
> >
> > Ok, I think they have to be submitted together though, because otherwise
> > the other drivers are more broken now.
> 
> Yes, makes sense. Will convert the others and submit the patches altogether.
> 
> Do you think I should also remove the "pdata" references, ie, let the
> driver be dt-only?
> 
> I do not see any users for the da9052 drivers, except for mx53qsb,
> which I added two days ago.
> 

Definitely fine with me.

	Arnd
