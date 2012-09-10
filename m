Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2IJDyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:54:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59063 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2IJDyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:54:16 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4737A960563B524DA805CA602BE04B3064CC590795@SC-VEXCH2.marvell.com>
References: <4737A960563B524DA805CA602BE04B3064CC590795@SC-VEXCH2.marvell.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 10 Sep 2012 11:53:55 +0800
Message-ID: <CAF+7xWky1N=LHd01aiewEVEhNNLNnuBHHqCBsTHhVd_SbPMjaA@mail.gmail.com>
Subject: Re: [PATCH] regulator: fan53555: remove vsel_max not used
To: Yunfan Zhang <yfzhang@marvell.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/10 Yunfan Zhang <yfzhang@marvell.com>:
> The max voltage will be bounded by min_uV, uV_step and n_voltages, so
> remove it to avoid confusing.
>
> Signed-off-by: Yunfan Zhang <yfzhang@marvell.com>
Acked-by: Axel Lin <axel.lin@gmail.com>
