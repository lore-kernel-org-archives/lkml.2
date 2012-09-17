Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2IQHtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:49:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47999 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2IQHtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:49:21 -0400
MIME-Version: 1.0
In-Reply-To: <1345662238-15211-3-git-send-email-ddaney.cavm@gmail.com>
References: <1345662238-15211-1-git-send-email-ddaney.cavm@gmail.com>
	<1345662238-15211-3-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 17 Sep 2012 09:49:20 +0200
Message-ID: <CAMSQXEHXG=DGT7egbSfdNb2VFTXS+HQ0DoaA2v9dTX_2zn2pZg@mail.gmail.com>
Subject: Re: [PATCH 2/2] misc/at25: Add an .id_table to at25 to facilitate
 driver loading and binding.
From: Ivo Sieben <meltedpianoman@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/8/22 David Daney <ddaney.cavm@gmail.com>:
> From: David Daney <david.daney@cavium.com>
>
>  /*-------------------------------------------------------------------------*/
> +static const struct spi_device_id at25_id[] = {
> +       {"at25", 0},
> +       {"m95256", 0},
> +       { }
> +};
> +MODULE_DEVICE_TABLE(spi, at25_id);

I use this driver for the ST M95040, M95020 & M95010 eeprom devices.
So wouldn't it be better to use the "famliy" name for these chips
("m95" instead of "m95256").

Regards,
Ivo Sieben
