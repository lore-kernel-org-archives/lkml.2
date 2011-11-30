Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab1K3JqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:46:16 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59046 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1K3JqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:46:15 -0500
Date: Wed, 30 Nov 2011 09:46:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        NeilBrown <neilb@suse.de>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111130094609.GA19839@sirena.org.uk>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
 <201111251402.28016.arnd@arndb.de>
 <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
 <20111127230836.GA29728@suse.de>
 <20111128123114.2601bd7c@notabene.brown>
 <20111128072713.GA17724@suse.de>
 <20111128090446.GB18919@core.coreip.homeip.net>
 <20111130063500.GB12052@suse.de>
 <CAJ0PZbR_N+=51AkcP5ijP31ka7G7EXbL8hSzK+umd_W6HPP2gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0PZbR_N+=51AkcP5ijP31ka7G7EXbL8hSzK+umd_W6HPP2gg@mail.gmail.com>
X-Cookie: If rash develops, discontinue use.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 03:58:54PM +0900, MyungJoo Ham wrote:
> On Wed, Nov 30, 2011 at 3:35 PM, Greg KH <gregkh@suse.de> wrote:

> > Actually, why can't we just use gpio as-is here and just treat these
> > devices as "generic" i/o "pins"?

> For userspace, GPIO should work.

> For device drivers, I'm not sure.

> In order to work for device drives, a GPIO event (GPIO Input goes L->H
> or H->L) should trigger events in other device drivers. The GPIO value
> can be set by the external-connector/multistate-switch driver
> (notifier) based on its own interrupts.

We also need some way to group things together so that we can understand
that we've got a single connector that can detect multiple things (eg,
understanding that a cable hsa audio and video capability).
