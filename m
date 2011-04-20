Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1DTLAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:00:21 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:52084 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752707Ab1DTLAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:00:19 -0400
Date: Wed, 20 Apr 2011 12:51:20 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-at91: gsia18s board improvements and bug fixes
Message-ID: <20110420105120.GI4204@game.jcrosoft.org>
References: <1303291399-4075-1-git-send-email-plyatov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303291399-4075-1-git-send-email-plyatov@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13600589400494680935
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:23 Wed 20 Apr     , Igor Plyatov wrote:
> * AT91_PIN_Pxxx port names replaced by human readable GPO_xxxx, GPI_xxxx,
I do not see the improvement
>   GPIO_xxxx names. This simplify source code and schematic maintenance.
> * Active logic levels and default states corrected for GPOs.
> * Replace small functions which use platform_register_device() by its direct
>   calls.
ditto here
> * Remove GPIO_CARD_UNMOUNT_1 gpio_keys_button, because it not used.
> * debounce_interval added for critical buttons.
> * Remove unneeded GPI setup code for buttons, because this done by corresponding
>   driver.
> * pcf8574x_0x20_setup() and pcf8574x_0x20_teardown functions small refactoring.
Best Regards,
J.
