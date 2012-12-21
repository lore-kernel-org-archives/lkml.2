Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2LUQVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:21:30 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:56802 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2LUQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:21:19 -0500
X-Greylist: delayed 1641 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 11:21:18 EST
MIME-Version: 1.0
In-Reply-To: <1355794210.5681.1.camel@phoenix>
References: <1355794210.5681.1.camel@phoenix>
Date: Fri, 21 Dec 2012 23:53:56 +0800
Message-ID: <CAN1soZzsMwrqx2H7ZnPHZMndUw_q+TXEDb5+fJhgszfR8XOFGA@mail.gmail.com>
Subject: Re: [PATCH 1/4] regulator: core: Allow specify apply_[reg|bit] for
 regmap based voltage_sel operations
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 9:30 AM, Axel Lin <axel.lin@ingics.com> wrote:
> Some DVM regulators needs to update apply_bit after setting vsel_reg to
> initiate voltage change on the output.  This patch adds apply_reg and
> apply_bit to struct regulator_desc and update
> regulator_set_voltage_sel_regmap() to set apply_bit of apply_reg when
> apply_bit is set.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/core.c         |   12 +++++++++++-
>  include/linux/regulator/driver.h |    6 ++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
