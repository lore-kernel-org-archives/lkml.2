Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0FNJaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:30:19 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:51058 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab0FNJaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:30:17 -0400
Message-ID: <19477.63136.664249.167207@ipc1.ka-ro>
Date: Mon, 14 Jun 2010 11:30:08 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
In-Reply-To: <1276507378.2552.39.camel@pasglop>
References: <1275636608.606606.450179637764.0.gpush@pororo>
	<201006111557.12249.jeremy.kerr@canonical.com>
	<19473.61547.684572.647641@ipc1.ka-ro>
	<201006111718.47426.jeremy.kerr@canonical.com>
	<19474.172.742782.972629@ipc1.ka-ro>
	<20100611095839.GC10894@pengutronix.de>
	<19474.2817.333749.485028@ipc1.ka-ro>
	<1276319643.1962.181.camel@pasglop>
	<19477.52889.982995.407051@ipc1.ka-ro>
	<1276507378.2552.39.camel@pasglop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:
> On Mon, 2010-06-14 at 08:39 +0200, Lothar Waßmann wrote:
> > All implementations so far use spin_lock_irq_save()!
> 
> Nothing prevents your implementation to be a tad smarter.
> 
I vote for consistency, so that device drivers can be kept arch
independent instead of having to care about implentation details of
each arch.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
