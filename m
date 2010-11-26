Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0KZM0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:26:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55613 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0KZM0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:26:43 -0500
Subject: Re: [PATCH 0/4] Fixes resource leaks for Samsung SoCs
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Graeme Gregory <graeme@openmoko.org>,
        Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Seungwhan Youn <sw.youn@samsung.com>,
        Jassi Brar <jassi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290754245.25125.1.camel@mola>
References: <1290754245.25125.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 12:26:36 +0000
Message-ID: <1290774396.3298.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 14:50 +0800, Axel Lin wrote:
> This serial of patches fixes resource leaks for Samsung SoCs.
> 
> Axel Lin (4):
>   ASoC: Fix resource leask in goni_wm8994.c
>   ASoC: Fix resource leask in neo1973_gta02_init() error path
>   ASoC: Add missing gpio_free(S3C64XX_GPK(12)) in smartq_exit()
>   ASoC: Fix resource leask in smdk_spdif.c
> 
>  sound/soc/samsung/goni_wm8994.c          |    9 +++++++--
>  sound/soc/samsung/neo1973_gta02_wm8753.c |   22 +++++++++++-----------
>  sound/soc/samsung/smartq_wm8987.c        |    1 +
>  sound/soc/samsung/smdk_spdif.c           |   13 +++++++++----
>  4 files changed, 28 insertions(+), 17 deletions(-)
> 

All 

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

