Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0K2LBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:01:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48020 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751860Ab0K2LB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:01:29 -0500
Date: Mon, 29 Nov 2010 11:01:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org, Jassi Brar <jassi.brar@samsung.com>,
        Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Graeme Gregory <graeme@openmoko.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Seungwhan Youn <sw.youn@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] [PATCH 0/4] Fixes resource leaks for Samsung SoCs
Message-ID: <20101129110127.GO30360@rakim.wolfsonmicro.main>
References: <1290754245.25125.1.camel@mola>
 <AANLkTi=A7LcN6Eoh8WnT2g5TBpFb12ogWncYjZzFeZg3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=A7LcN6Eoh8WnT2g5TBpFb12ogWncYjZzFeZg3@mail.gmail.com>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 08:40:29AM +0900, Jassi Brar wrote:
> On Fri, Nov 26, 2010 at 3:50 PM, Axel Lin <axel.lin@gmail.com> wrote:
> > Axel Lin (4):
> >  ASoC: Fix resource leask in goni_wm8994.c
> >  ASoC: Fix resource leask in neo1973_gta02_init() error path
> >  ASoC: Add missing gpio_free(S3C64XX_GPK(12)) in smartq_exit()
> >  ASoC: Fix resource leask in smdk_spdif.c

> Acked-by: Jassi Brar <jassi.brar@samsung.com>

All applied now, thanks.
