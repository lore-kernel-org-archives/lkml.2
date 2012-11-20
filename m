Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2KTNCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:02:20 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:55431 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab2KTNCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:02:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, broonie@opensource.wolfsonmicro.com,
        khali@linux-fr.org, ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 3/3] i2c / ACPI: add ACPI enumeration support
Date: Tue, 20 Nov 2012 14:06:46 +0100
Message-ID: <2231474.figQz3Mgq6@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353407384-26880-4-git-send-email-mika.westerberg@linux.intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com> <1353407384-26880-4-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 20, 2012 12:29:44 PM Mika Westerberg wrote:
> ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> and configure the I2C slave devices behind the I2C controller. This patch
> adds helper functions to support I2C slave enumeration.
> 
> An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> in order to get its slave devices enumerated, created and bound to the
> corresponding ACPI handle.

My comments from the SPI patch apply here too almost verbatim. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
