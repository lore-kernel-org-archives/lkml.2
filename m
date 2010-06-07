Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0FGM7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:59:53 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44959 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab0FGM7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:59:52 -0400
Subject: Re: [PATCH v6] regulator: new drivers for AD5398 and AD5821
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: sonic zhang <sonic.adi@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
In-Reply-To: <1275626446.1515.5.camel@eight.analog.com>
References: <1275626446.1515.5.camel@eight.analog.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 13:59:48 +0100
Message-ID: <1275915588.3045.108.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 12:40 +0800, sonic zhang wrote:
> >From 32646efc2e7fb19945a10ad3f1172d6f751186b8 Mon Sep 17 00:00:00 2001
> From: Sonic Zhang <sonic.zhang@analog.com>
> Date: Fri, 4 Jun 2010 11:46:04 +0800
> Subject: [PATCH v6] regulator: new drivers for AD5398 and AD5821
> 
> The AD5398 and AD5821 are single 10-bit DAC with 120 mA output current
> sink capability. They feature an internal reference and operates from
> a single 2.7 V to 5.5 V supply.
> 
> This driver supports both the AD5398 and the AD5821.  It adapts into the
> voltage and current framework.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/regulator/Kconfig  |    6 +
>  drivers/regulator/Makefile |    1 +
>  drivers/regulator/ad5398.c |  288 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 295 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/ad5398.c
> 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

