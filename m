Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2FSITN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:19:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51092 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2FSITJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:19:09 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1340092423-10073-2-git-send-email-yadi.brar@samsung.com>
References: <1340092423-10073-1-git-send-email-yadi.brar@samsung.com> <1340092423-10073-2-git-send-email-yadi.brar@samsung.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 19 Jun 2012 16:18:48 +0800
Message-ID: <CAF+7xWkopYu2CkPsdPeJ5Kr0NBbYcnf2ez-hC+RCj6QuOFcstw@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: max77686: Implement .set_ramp_delay() callback.
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static struct regulator_ops max77686_ops = {
>        .list_voltage           = regulator_list_voltage_linear,
>        .map_voltage            = regulator_map_voltage_linear,
> @@ -90,6 +114,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
>        .get_voltage_sel        = regulator_get_voltage_sel_regmap,
>        .set_voltage_sel        = regulator_set_voltage_sel_regmap,
>        .set_voltage_time_sel   = regulator_set_voltage_time_sel,
> +       .set_ramp_delay         = max77686_set_ramp_delay,
>  };

I think what you want here is to set .set_ramp_delay callback for
max77686_buck_dvs_ops
rather than max77686_ops.
