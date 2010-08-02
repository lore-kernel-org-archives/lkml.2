Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0HBF1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 01:27:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37586 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0HBF1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 01:27:07 -0400
Date: Mon, 2 Aug 2010 07:26:54 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "avictor.za@gmail.com" <avictor.za@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "Samuel R. C. Vale" <srcvale@holoscopio.com>,
        Jiri Kosina <jkosina@suse.cz>, Andrew Victor <linux@maxim.org.za>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] ARM: cam60: move cam60_spi_devices to .init.data
Message-ID: <20100802052653.GA8538@pengutronix.de>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de> <AANLkTi=hPg-12w9ihz-RsvD0d6Zawus14qF9hamA6nES@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=hPg-12w9ihz-RsvD0d6Zawus14qF9hamA6nES@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sun, Aug 01, 2010 at 11:23:35PM +0200, avictor.za@gmail.com wrote:
> > cam60_spi_devices is passed to at91_add_device_spi which calls
> > spi_register_board_info.  The latter makes a copy of it, so living in
> > .init.data is OK.
> 
> The  copy still maintains a pointers to
> "cam60_spi_flash_platform_data", so I'm wondering if that and
> "cam60_spi_partitions" should maybe not be marked as __initdata.
I think that's right, these need to be fixed up.  Thanks for noticing, I
will prepare a patch later today.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
