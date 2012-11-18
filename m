Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2KRXQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 18:16:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54514 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2KRXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 18:15:59 -0500
Date: Sun, 18 Nov 2012 15:12:40 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20121118231239.GC29066@lizard.sbx05977.paloaca.wayport.net>
References: <19040462.WFXWijAIDd@pali>
 <20121030223922.GA29061@lizard>
 <2562836.SjVVyiPAk1@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2562836.SjVVyiPAk1@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:48:40AM +0100, Pali Rohár wrote:
> Hello, I fixed style issues and added it to Makefile and Kconfig.
> 
> power_supply: Add Nokia RX-51 battery driver
> 
> This driver exporting battery design capacity, temperature and voltage
> for battery in Nokia RX-51. This driver is needed for open source
> battery management on Nokia RX-51 (N900).
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Looks great, thank you! This is now in the battery git tree.

p.s.

fwiw, I added the N900 reference to the user-visible Kconfig text:

 config BATTERY_RX51
-	tristate "Nokia RX-51 battery driver"
+	tristate "Nokia RX-51 (N900) battery driver"
 	depends on TWL4030_MADC
 	help
-	  Say Y here to enable support for battery information on Nokia RX-51.
+	  Say Y here to enable support for battery information on Nokia
+	  RX-51, also known as N900 tablet.
