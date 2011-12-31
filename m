Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1LaAQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 19:16:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47999 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab1LaAQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 19:16:25 -0500
MIME-Version: 1.0
In-Reply-To: <1325215093.2569.8.camel@phoenix>
References: <1325214804.2569.3.camel@phoenix>
	<1325215093.2569.8.camel@phoenix>
Date: Sat, 31 Dec 2011 08:16:25 +0800
Message-ID: <CAN1soZwCxJVCKxSwH=s2UNnp5MaoFCawRZL4SdhT7Cbo9E4nUg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 3/3] ASoC: pxa: Convert corgi to use snd_soc_register_card()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 11:18 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Use snd_soc_register_card() instead of creating a "soc-audio" platform device.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/mach-pxa/corgi.c |    9 +++++++++
>  sound/soc/pxa/corgi.c     |   43 +++++++++++++++++++++++--------------------
>  2 files changed, 32 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
