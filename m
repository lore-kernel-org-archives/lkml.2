Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab1GDOTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:19:33 -0400
Received: from gate.eia.be ([194.78.71.18]:11340 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab1GDOTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:19:31 -0400
Date: Mon, 4 Jul 2011 16:19:24 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ryan Mallon <rmallon@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Bill Gatliff <bgat@billgatliff.com>, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
Message-ID: <20110704141924.GF316@e-circ.dyndns.org>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Ryan Mallon <rmallon@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Bill Gatliff <bgat@billgatliff.com>, linux-kernel@vger.kernel.org,
	Ryan Mallon <ryan@bluewatersys.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org
References: <201106301441.24493.arnd@arndb.de>
 <4E11994B.7070103@gmail.com>
 <20110704110523.GB316@e-circ.dyndns.org>
 <201107041553.07643.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201107041553.07643.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Jul 2011 14:19:28.0515 (UTC) FILETIME=[6271AD30:01CC3A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 03:53:07PM +0200, Arnd Bergmann wrote:
> On Monday 04 July 2011, Kurt Van Dijck wrote:
> > With socketCAN, we encountered a similar problem. Every chip maker
> > tries to create added value by means of special options. You can't
> > support them all in the framework. Therefore, sysfs can be added
> > to configure special things.
> 
> I would expect that pwm is much simpler than CAN,
ack
> so the amount
> of creativity there is also limited.
That is true for a single PWM channel.
With multiple PWM channels, hardware design tends to be creative in coupling
several channels together somehow in order to create some diesel engine
control signal ...
> 
> 	Arnd

Anyway, I explained my concern. It's just _an_ opinion.
Kurt
