Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2EUQG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:06:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57036 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab2EUQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:06:56 -0400
MIME-Version: 1.0
Date: Mon, 21 May 2012 13:06:55 -0300
Message-ID: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
Subject: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

I am running linux-next 3.4.0-next-20120521 on a mx31pdk board that
has a mc13783 PMIC connected to SPI.

I am getting a kernel hang after 'regmap_read' inside mc13xxx_reg_read function.

Does it work fine for you on your mx35 board? Am I missing any recent patch?

My understanding is that you have only tested i2c connection with this
PMIC. Is this correct?

Any ideas on how to solve this issue is appreciated.

Regards,

Fabio Estevam
