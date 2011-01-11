Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1AKKad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:30:33 -0500
Received: from adelie.canonical.com ([91.189.90.139]:51656 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab1AKKaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:30:30 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: Locking in the clk API
Date: Tue, 11 Jan 2011 18:30:18 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com> <201101111744.59712.jeremy.kerr@canonical.com> <20110111101314.GA774@linux-sh.org>
In-Reply-To: <20110111101314.GA774@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101111830.18597.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> No, the sleeping clock case is and always will be a corner case, and I
> have no interest in pretending otherwise. On SH we have hundreds of
> clocks that are all usable in the atomic context and perhaps less than a
> dozen that aren't (and even in those cases much of the PLL negotiation is
> handled in hardware so there's never any visibility for the lock-down
> from the software side, other architectures also have similar behaviour).

I'm not too worried about the corner-cases on the *implementation* side, more 
the corner-cases on the API side: are we seeing more users of the API that 
require an atomic clock, or more that don't care?

Cheers,


Jeremy
