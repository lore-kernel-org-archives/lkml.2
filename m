Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2K0IiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:38:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2K0IiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:38:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
Date: Tue, 27 Nov 2012 08:37:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>
References: <20121127155732.c3422fdbf62501ee134024d7@canb.auug.org.au>
In-Reply-To: <20121127155732.c3422fdbf62501ee134024d7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211270837.48458.arnd@arndb.de>
X-Provags-ID: V02:K0:vw1jnZf6rK2ePuiQ2tKhluDafGaoXUeZkxr/L/LOOPD
 cbGv5lcfb6vg45jPlTXXUPJ+q79LDJHfGNrFkMQ4ansm6n5bBx
 m8x4lgK03krhnlwngsYQA3Ttso2ZAiuhkW34D0apZxX54oXVAO
 oxYa4E3IGj1Dwg7x/vG21hVzFjt0ue7qfxOVZBbOZUOMBbwCvv
 Wvgqc8v8ZCtUyzlgNSH7lrx60NpAZZtVkydvKmRuh4TCtXPROU
 Eu3xf1OfU4zj8mn39TIlhsm6nGfVYI6nbuCQbX7Briai0Ycdob
 6pJzjDTvvBPHX6DOkT2KNcOLhRboJMoNVem6X8IJHlKw/nua8X
 0YEdzqcUi036IN9hXDHE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2012, Stephen Rothwell wrote:
> @@@ -167,7 -184,9 +170,9 @@@ ehci_orion_conf_mbus_windows(struct usb
>         }
>   }
>   
> + static u64 ehci_orion_dma_mask = DMA_BIT_MASK(32);
> + 
>  -static int __devinit ehci_orion_drv_probe(struct platform_device *pdev)
>  +static int ehci_orion_drv_probe(struct platform_device *pdev)
>   {
>         struct orion_ehci_data *pd = pdev->dev.platform_data;
>         const struct mbus_dram_target_info *dram;

Looks good, thanks!

	Arnd
