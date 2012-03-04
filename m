Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2CDTxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 14:53:22 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:17450 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab2CDTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 14:53:16 -0500
Date: Sun, 4 Mar 2012 20:52:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V5 1/3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120304205259.266bc636@endymion.delvare>
In-Reply-To: <9e456f42-7eee-4b36-bf8e-f8095619382c@zimbra>
References: <e6719b9b-0b6d-49b4-a5eb-16b04d25a719@zimbra>
	<9e456f42-7eee-4b36-bf8e-f8095619382c@zimbra>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron, Grant,

On Mon, 20 Feb 2012 19:10:41 -0600 (CST), Aaron Sierra wrote:
> This driver currently creates resources for use by a forthcoming ICH
> chipset GPIO driver. It could be expanded to create the resources for
> converting the esb2rom (mtd) and iTCO_wdt (wdt), and potentially more,
> drivers to use the mfd model.
> 
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/mfd/Kconfig         |    9 +
>  drivers/mfd/Makefile        |    1 +
>  drivers/mfd/lpc_ich.c       |  717 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/lpc_ich.h |   41 +++
>  4 files changed, 768 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/lpc_ich.c
>  create mode 100644 include/linux/mfd/lpc_ich.h
> (...)

What's the current state of this patch set ? It works fine for me after
applying Guenter's fix and passing acpi_enforce_resources=lax at boot
time. It would be great if these patches could be scheduled for merge
in kernel 3.4, if they haven't already.

Thanks,
-- 
Jean Delvare
