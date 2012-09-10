Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2IJIai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:30:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59597 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2IJIae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:30:34 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120910075838.GE6749@opensource.wolfsonmicro.com>
References: <4737A960563B524DA805CA602BE04B3064CC590795@SC-VEXCH2.marvell.com>
 <CAF+7xWky1N=LHd01aiewEVEhNNLNnuBHHqCBsTHhVd_SbPMjaA@mail.gmail.com> <20120910075838.GE6749@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 10 Sep 2012 16:30:13 +0800
Message-ID: <CAF+7xWm+r4zKMcK1Zi-QThG0YL-9KQa6iwNCiLbmvLUu65rVyA@mail.gmail.com>
Subject: Re: [PATCH] regulator: fan53555: remove vsel_max not used
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yunfan Zhang <yfzhang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/10 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Sep 10, 2012 at 11:53:55AM +0800, Axel Lin wrote:
>> 2012/9/10 Yunfan Zhang <yfzhang@marvell.com>:
>> > The max voltage will be bounded by min_uV, uV_step and n_voltages, so
>> > remove it to avoid confusing.
>
> Applied, thanks.
>
>> Acked-by: Axel Lin <axel.lin@gmail.com>
>
> I think you meant to say Reviewed-by here - Acked mostly just means that
Ah.. yes. should be Reviewed-by here.

> you're OK with the patch being applied, it's not really saying anything
> strong about the patch having been properly reviewed.

Thanks for the clarification.
Axel
