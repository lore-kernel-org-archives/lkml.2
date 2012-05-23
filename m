Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2EWBNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:13:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60485 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2EWBNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:13:00 -0400
MIME-Version: 1.0
In-Reply-To: <201205221053.21792.marc@cpdesign.com.au>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
Date: Tue, 22 May 2012 22:12:59 -0300
Message-ID: <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: marc@cpdesign.com.au
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

On Mon, May 21, 2012 at 9:53 PM, Marc Reilly <marc@cpdesign.com.au> wrote:

> Does your crash occur during mc13xxx_spi_probe?

Yes

> does mc13xxx_common_init() get  called?

Yes

The sequence that shows the problem is:

mc13xxx_spi_probe
mc13xxx_common_init
mc13xxx_identify
mc13xxx_reg_read
regmap_read (kernel hangs)
