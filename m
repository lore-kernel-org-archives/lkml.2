Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab1LOHDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:03:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44655 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab1LOHDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:03:17 -0500
Date: Thu, 15 Dec 2011 07:03:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] irq: fix crash due to op-less irq domains
Message-ID: <20111215070313.GA28733@sirena.org.uk>
References: <1323896156-20692-1-git-send-email-linus.walleij@stericsson.com>
 <4EE91FDD.5070206@gmail.com>
 <CACRpkdZTCqcCmdqugwos+23Q5YXDcMvt48GFy8guVuSTWWtrpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZTCqcCmdqugwos+23Q5YXDcMvt48GFy8guVuSTWWtrpA@mail.gmail.com>
X-Cookie: YOW!!  The land of the rising SONY!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:24:59PM +0100, Linus Walleij wrote:

> If I just have the baseline in linux-next, I can fix it, but then I need
> that patch in linux-next first, now all non-devicetree VIC systems are
> just broken with no way for me to fix them :-(

Yes, this really needs fixing - I've been carrying the same patch as
Linus plus three more found due to the same problems for a while now in
order to allow me to boot my systems.
