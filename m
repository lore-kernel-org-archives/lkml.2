Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030194Ab2K3Lbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:31:50 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36770 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab2K3Lbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:31:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, broonie@opensource.wolfsonmicro.com,
        khali@linux-fr.org, ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 2/3] spi / ACPI: add ACPI enumeration support
Date: Fri, 30 Nov 2012 12:36:35 +0100
Message-ID: <1790246.ZXGOxKFoz2@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121130112413.8059C3E14C4@localhost>
References: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com> <1353435212-15325-3-git-send-email-mika.westerberg@linux.intel.com> <20121130112413.8059C3E14C4@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 30, 2012 11:24:13 AM Grant Likely wrote:
> On Tue, 20 Nov 2012 20:13:31 +0200, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> > ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> > configure the SPI slave devices behind the SPI controller. This patch adds
> > support for this to the SPI core.
> > 
> > In addition we bind ACPI nodes to SPI devices. This makes it possible for
> > the slave drivers to get the ACPI handle for further configuration.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thanks a lot!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
