Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1JKKBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:01:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60159 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1JKKBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:01:16 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1317857999.6291.3.camel@phoenix>
References: <1317857999.6291.3.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 11 Oct 2011 18:00:55 +0800
Message-ID: <CAF+7xWnuApJfdnpj4yajfYepw8syEdeH_wHOL6wmprPv_MAZmg@mail.gmail.com>
Subject: Re: [PATCH RESEND] ASoC: Remove impossible case from wm8994_hw_params
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/6 Axel Lin <axel.lin@gmail.com>:
> We set hw_params callback for wm8994_aif3_dai_ops to wm8994_aif3_hw_params.
> Thus no need to check wm8994-aif3 in wm8994_hw_params.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
hi Mark,
Seems this patch is missed. This resend should be appliable to current code.

Thanks,
Axel
