Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2FLQjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:39:46 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:5042 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2FLQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:39:45 -0400
Date: Tue, 12 Jun 2012 18:39:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Rudolf Marek <r.marek@assembler.cz>, Olof Johansson <olof@lixom.net>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: use module_pci_driver
Message-ID: <20120612183932.010725a8@endymion.delvare>
In-Reply-To: <20120612153432.GA24753@pengutronix.de>
References: <1339505279.12492.1.camel@phoenix>
	<20120612153432.GA24753@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012 17:34:32 +0200, Wolfram Sang wrote:
> On Tue, Jun 12, 2012 at 08:47:59PM +0800, Axel Lin wrote:
> > This patch converts the drivers in drivers/i2c/buses/* to use
> > module_pci_driver() macro which makes the code smaller and a bit simpler.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
> > Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
> > Cc: "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
> > Cc: Rudolf Marek <r.marek@assembler.cz>
> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> > Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> 
> Looks good to me
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> 
> Jean, let me know if you think this is embedded realm.

I'll take it, most drivers affected are for PC/x86 boards.

-- 
Jean Delvare
