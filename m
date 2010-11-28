Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0K1Xkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 18:40:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54282 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab0K1Xkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 18:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tAKm8RJUeE5Ru2ki62H52SfnXErckpnsF8Ijs+WYy1IOC5OmJBHEdGsEeGZH/78EnJ
         XFxaGqxv4behv307Trz0OI9I2z2EcduW6hGsFO/xbXdCCa8fRPLeWIBicIFEjO7HXZXz
         8x4qtrOzcSIUvBGOxMc58Goq5MYnDMhiP4O7M=
MIME-Version: 1.0
In-Reply-To: <1290754245.25125.1.camel@mola>
References: <1290754245.25125.1.camel@mola>
Date: Mon, 29 Nov 2010 08:40:29 +0900
Message-ID: <AANLkTi=A7LcN6Eoh8WnT2g5TBpFb12ogWncYjZzFeZg3@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 0/4] Fixes resource leaks for Samsung SoCs
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
        Jassi Brar <jassi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Graeme Gregory <graeme@openmoko.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Seungwhan Youn <sw.youn@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 3:50 PM, Axel Lin <axel.lin@gmail.com> wrote:
> This serial of patches fixes resource leaks for Samsung SoCs.
>
> Axel Lin (4):
>  ASoC: Fix resource leask in goni_wm8994.c
>  ASoC: Fix resource leask in neo1973_gta02_init() error path
>  ASoC: Add missing gpio_free(S3C64XX_GPK(12)) in smartq_exit()
>  ASoC: Fix resource leask in smdk_spdif.c

Acked-by: Jassi Brar <jassi.brar@samsung.com>
