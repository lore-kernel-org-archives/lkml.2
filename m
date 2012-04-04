Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2DDM1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:27:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39158 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab2DDM1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:27:10 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1333506730.15318.2.camel@phoenix>
References: <1333506730.15318.2.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 4 Apr 2012 20:26:48 +0800
Message-ID: <CAF+7xWmyPTCcTRjfH1QHZ2yGEXnt_PVrT3P3EqjDQAX0nY8Zgg@mail.gmail.com>
Subject: Re: [PATCH] regulator: Support set_voltage_time_sel for drivers
 implement set_voltage
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/4 Axel Lin <axel.lin@gmail.com>:
> In currently implementation of _regulator_do_set_voltage, set_voltage_time_sel will
> only be called if set_voltage_sel is implemented.
>
> set_voltage_time_sel actually only needs get_voltage_sel to get old_selector.
>
> This patch makes regulator core support set_voltage_time_sel for drivers
> implement either set_voltage or set_voltage_sel.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

I forgot to mention that s5m8767 needs this patch to work.
s5m8767 implements set_voltage, get_voltage_sel and
set_voltage_time_sel callbacks.

Regards,
Axel
