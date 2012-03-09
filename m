Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2CIIZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:25:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:54756 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751879Ab2CIIZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:25:48 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1331279829-4584-1-git-send-email-paul.liu@linaro.org>
References: <1331279829-4584-1-git-send-email-paul.liu@linaro.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 9 Mar 2012 16:25:28 +0800
Message-ID: <CAF+7xWkA-rDML03U=7d30ipXV9buhbqnZYWS54nGVKZbkYxXJw@mail.gmail.com>
Subject: Re: [PATCH v11] Regulator: Add Anatop regulator driver
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/9 Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>
> Anatop is an integrated regulator inside i.MX6 SoC.
> There are 3 digital regulators which controls PU, CORE (ARM), and SOC.
> And 3 analog regulators which controls 1P1, 2P5, 3P0 (USB).
> This patch adds the Anatop regulator driver.
>
> Signed-off-by: Nancy Chen <Nancy.Chen@freescale.com>
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Axel Lin <axel.lin@gmail.com>

The rdesc->n_voltage setting is missing.
Otherwise, Reviewed-by: Axel Lin <axel.lin@gmail.com>
