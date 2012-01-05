Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab2AEU0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:26:09 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:10306 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab2AEU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:26:07 -0500
Date: Thu, 5 Jan 2012 21:25:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rudolf Marek <r.marek@assembler.cz>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Olof Johansson <olof@lixom.net>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH RESEND] i2c: Convert to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20120105212553.02d69dda@endymion.delvare>
In-Reply-To: <1325076512.6997.1.camel@phoenix>
References: <1325076512.6997.1.camel@phoenix>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Dec 2011 20:48:32 +0800, Axel Lin wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables.
> 
> Use DEFINE_PCI_DEVICE_TABLE ensures we make the pci_device_id table const
> and marked as __devinitconst.
> 
> This also fixes some warnings from checkpatch:
> e.g.
> WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> #1096: FILE: i2c/busses/i2c-intel-mid.c:1096:
> +static struct pci_device_id intel_mid_i2c_ids[] = {
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: linux-i2c@vger.kernel.org
> ---
> This resend updates the change log.
> This patch is against linux-next tree.
> Axel
> 
>  drivers/i2c/busses/i2c-ali1563.c           |    2 +-
>  drivers/i2c/busses/i2c-ali15x3.c           |    2 +-
>  drivers/i2c/busses/i2c-amd756.c            |    2 +-
>  drivers/i2c/busses/i2c-amd8111.c           |    2 +-
>  drivers/i2c/busses/i2c-designware-pcidrv.c |    2 +-
>  drivers/i2c/busses/i2c-eg20t.c             |    2 +-
>  drivers/i2c/busses/i2c-hydra.c             |    2 +-
>  drivers/i2c/busses/i2c-i801.c              |    2 +-
>  drivers/i2c/busses/i2c-intel-mid.c         |    2 +-
>  drivers/i2c/busses/i2c-nforce2.c           |    2 +-
>  drivers/i2c/busses/i2c-pasemi.c            |    2 +-
>  drivers/i2c/busses/i2c-piix4.c             |    2 +-
>  drivers/i2c/busses/i2c-pxa-pci.c           |    2 +-
>  drivers/i2c/busses/i2c-sis5595.c           |    2 +-
>  drivers/i2c/busses/i2c-sis630.c            |    2 +-
>  drivers/i2c/busses/i2c-sis96x.c            |    2 +-
>  drivers/i2c/busses/i2c-via.c               |    2 +-
>  drivers/i2c/busses/i2c-viapro.c            |    2 +-
>  drivers/i2c/busses/scx200_acb.c            |    2 +-
>  19 files changed, 19 insertions(+), 19 deletions(-)
> (...)

Applied, thanks!

-- 
Jean Delvare
