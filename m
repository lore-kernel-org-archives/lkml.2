Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2HCQH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:07:58 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:45832 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2HCQHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:07:55 -0400
Date: Fri, 3 Aug 2012 18:07:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Amaury =?UTF-8?B?RGVjcsOqbWU=?= <amaury.decreme@gmail.com>
Cc: ben-linux@fluff.org, w.sang@pengutronix.de, rob@landley.net,
        jeffrey.t.kirsher@intel.com, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        ralf@linux-mips.org, dirk.brandewie@gmail.com,
        jayachandranc@netlogicmicro.com, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] I2C: SIS964: Bus driver
Message-ID: <20120803180712.1e768042@endymion.delvare>
In-Reply-To: <1344008145-14579-1-git-send-email-amaury.decreme@gmail.com>
References: <1344008145-14579-1-git-send-email-amaury.decreme@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amaury,

On Fri,  3 Aug 2012 17:35:43 +0200, Amaury Decrême wrote:
> This series of patches are a I2C bus driver for the SIS964.
> 
> 
> The SIS964 is nearly the same as SIS630 for the SMBUS :
> 	- Most of the SMBus registers (Status, Enable, Control,
> 	  Host Control, etc.) are at the same adresses + 0x60
> 	- The register count is 21 instead of 20
> 
> The SIS964 name is ambiguous as this chip isn't part of the SIS96X
> family and behaves differently.
> 
> The datasheets have been used to develop the driver based on the
> exsiting driver for I2C SIS630 . 

What is the rationale for not adding support for the new chip to
i2c-sis630 then? That would probably be a lot easier to review.

> Content of the patches:
> 	- 1/2 The driver itself
> 	- 2/2 Documentation, Kconfig, Makefile, Maintainers

This split makes little sense. Integration should come with the driver,
otherwise even build-testing is impossible.


-- 
Jean Delvare
