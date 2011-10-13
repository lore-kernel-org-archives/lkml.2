Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1JMJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:16:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47817 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab1JMJQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:16:58 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <87ty7dl0uh.wl%kuninori.morimoto.gx@renesas.com>
References: <1318335653.3573.1.camel@phoenix> <87ty7dl0uh.wl%kuninori.morimoto.gx@renesas.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 13 Oct 2011 17:16:37 +0800
Message-ID: <CAF+7xW=10yL411_ko6GKsYtpy1mwteMPt3bUEikPoWfAae=fWA@mail.gmail.com>
Subject: Re: [PATCH] ASoC: ak4642: fixup cache register table
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/13 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>:
> ak4642 register was 8bit, but cache table was defined as 16bit.
> ak4642 doesn't work correctry without this patch.
>
ak4535 also has the same bug. I'm sending a patch for ak4535.

Regards,
Axel
