Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0KVNq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:46:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56437 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0KVNqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:46:24 -0500
Subject: Re: [PATCH] ASoC: s3c24xx: test wrong variable
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Jassi Brar <jassi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1290361223-15211-1-git-send-email-segoon@openwall.com>
References: <1290361223-15211-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 13:46:17 +0000
Message-ID: <1290433577.3309.21.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 20:40 +0300, Vasiliy Kulikov wrote:
> After clk_get() mclk is checked three times instead of mout_epll
> and sclk_spdif checks.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile this driver, so it is not tested.
> 
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

