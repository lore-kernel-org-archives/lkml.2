Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1INCGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 22:06:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37791 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1INCGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 22:06:17 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110913151420.GA23782@opensource.wolfsonmicro.com>
References: <1315925062.6042.1.camel@phoenix> <20110913151420.GA23782@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 14 Sep 2011 10:05:55 +0800
Message-ID: <CAF+7xWkkHFA-omWg88bZgZPe_s5aUF--HBOyf8Dr_b7ML-HuFQ@mail.gmail.com>
Subject: Re: [PATCH] ASoC: samsung: Fix checking return value of clk_get
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Christian Pellegrin <chripell@evolware.org>,
        Ben Dooks <ben@simtec.co.uk>, Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/13 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Sep 13, 2011 at 10:44:22PM +0800, Axel Lin wrote:
>> clk_get() returns a pointer to the struct clk or an ERR_PTR().
>
> Are you sure that the Samsung clock implementation actually does this?
>

Yes.
In arch/arm/Kconfig, all samsung platforms select CLKDEV_LOOKUP.
The implementation of clk_get() in drivers/clk/clkdev.c returns
ERR_PTR() on failure.

Regards,
Axel
