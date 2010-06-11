Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab0FKKu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:50:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37110 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732Ab0FKKuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:50:54 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Fri, 11 Jun 2010 18:50:30 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
References: <1275636608.606606.450179637764.0.gpush@pororo> <20100611095839.GC10894@pengutronix.de> <19474.2817.333749.485028@ipc1.ka-ro>
In-Reply-To: <19474.2817.333749.485028@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006111850.32528.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

> You may want to disable a clock in the IRQ handler. The VPU driver in
> the Freescale BSP for i.MX51 does exactly this.

Is this something we can defer to a sleepable context?

> Anyway I don't see any reason for using a mutex here instead of
> spin_lock_irq_save() as all other implementations do.

Just that enable/disable may take an arbitrarily long time to complete. Sounds 
like that hasn't been a problem in the past though.

Cheers,


Jeremy
