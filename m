Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab1JRDXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 23:23:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63346 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1JRDXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 23:23:23 -0400
MIME-Version: 1.0
In-Reply-To: <1318582987.19976.2.camel@phoenix>
References: <1318582919.19976.1.camel@phoenix> <1318582987.19976.2.camel@phoenix>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 18 Oct 2011 11:23:02 +0800
Message-ID: <CAGsJ_4xNAwyZcPkD-NQwF7Z=GzNPHAqDsBUteww4khWuuQv0jw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: ad193x: Use snd_soc_update_bits for read-modify-write
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Axel Lin <axel.lin@gmail.com>:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Barry Song <21cnbao@gmail.com>

and fix the changelog as Mark pointed out.

> ---
>  sound/soc/codecs/ad193x.c |   25 ++++++++++++-------------
>  1 files changed, 12 insertions(+), 13 deletions(-)
>

-barry
