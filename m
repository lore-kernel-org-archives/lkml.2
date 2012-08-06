Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2HFQgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:36:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37785 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2HFQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:36:17 -0400
Date: Mon, 6 Aug 2012 17:36:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Daniel Mack <zonque@gmail.com>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sven Neumann <s.neumann@raumfeld.com>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Emulating level IRQs
Message-ID: <20120806163615.GG29272@sirena.org.uk>
References: <20120503043651.GA11830@core.coreip.homeip.net>
 <20120713070102.GA2223@core.coreip.homeip.net>
 <500561AF.9090901@gmail.com>
 <5008296C.5070709@gmail.com>
 <20120723165120.GB26577@core.coreip.homeip.net>
 <500EE314.7040708@gmail.com>
 <501E9DDB.3020807@gmail.com>
 <CAN1soZy-_MdjqS3r3Tc1XET6tPzMxDqjYq3Tn0fYLBNNUkdVAg@mail.gmail.com>
 <501EB3C5.1080501@gmail.com>
 <CAMPhdO8fZoFrUymb347whDpFkbgxsu8vVSqw5BSd=L4gicfXgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMPhdO8fZoFrUymb347whDpFkbgxsu8vVSqw5BSd=L4gicfXgg@mail.gmail.com>
X-Cookie: Oatmeal raisin.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 09:45:13AM +0800, Eric Miao wrote:

> So my understanding, if it's correct, that we can treat the EETI chip as having
> two separate inputs: one IRQ line (for the event notification) and one GPIO line
> (for a condition where data are emptied), we could naturally have two numbers
> in the driver, but unfortunately they end up being in sync as they are
> physically
> one pin.

...unless the interrupt controller supports level IRQs at which point we
don't need the GPIO, of course :/ .
