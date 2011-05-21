Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab1EULVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 07:21:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45491 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1EULVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 07:21:07 -0400
Date: Sat, 21 May 2011 12:21:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Samsung: Move Samsung SoCs GPIO drivers to
	drivers/gpio
Message-ID: <20110521112102.GA11887@sirena.org.uk>
References: <20110520054441.GA9952@july> <20110520063128.GA21285@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520063128.GA21285@ponder.secretlab.ca>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:31:28AM -0600, Grant Likely wrote:
> On Fri, May 20, 2011 at 02:44:41PM +0900, Kyungmin Park wrote:
> >  .../gpiolib.c => drivers/gpio/s5pc100-gpio.c       |    0
> >  .../gpiolib.c => drivers/gpio/s5pv210-gpio.c       |    0
> >  .../gpiolib.c => drivers/gpio/samsung-gpiolib.c    |    3 +-

> drivers/gpio/gpio-*.c please.  I'm starting to enforce some level of
> naming convention.

Hrm, looking at the current mainline drivers the existing tendency seems
to be mostly towards gpio/*-gpio.c...
