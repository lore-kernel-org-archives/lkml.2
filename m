Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2LJFXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:23:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57870 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab2LJFXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:23:42 -0500
Date: Mon, 10 Dec 2012 14:23:36 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Liam Girdwood <lrg@ti.com>, matthias@kaehlcke.net,
        kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sound/soc/soc-core.c: drop kfree of devm_kzalloc's
 data
Message-ID: <20121210052334.GI10927@opensource.wolfsonmicro.com>
References: <1354989680-25794-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354989680-25794-1-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 07:01:20PM +0100, Julia Lawall wrote:

> The kfrees were introduced in b761c0ca.
> I sent this a few months ago, and I still think it should be applied...

I'm missing patches 1 and 2?
