Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2IQVvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:51:35 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30612 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754112Ab2IQVvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:51:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19NQhKUnpcqNA3aKMpVmFwe
Date: Mon, 17 Sep 2012 14:51:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to
 drivers/bus/
Message-ID: <20120917215128.GF11762@atomide.com>
References: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [120914 02:21]:
> OMAP interconnect drivers are used for the interconnect error handling.
> Since they are bus driver, lets move it to newly created drivers/bus.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Tony Lindgren <tony@atomide.com>
> Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
> Patch just moves OMAP interconnect drivers as is to the newly created
> driver/bus/* directory. Patch is generated against "arm-soc/drivers/ocp2scp"
> tree and test on all OMAP boards.

Great, looks like this should not conflict with other
omap patches queued, so Arnd should probably take this into
the bus branch:

Acked-by: Tony Lindgren <tony@atomide.com>
