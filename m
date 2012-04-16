Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2DPWwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:52:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62784 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2DPWwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <4F8CC0E9.3010407@xenotime.net>
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
	<4F8CC0E9.3010407@xenotime.net>
Date: Mon, 16 Apr 2012 19:52:04 -0300
Message-ID: <CAOMZO5BXn=LpEpyzcYqn=dSYhO2orBLwYD=XStFPqVhtr5S-6Q@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH -next] soc: fix printk format in soc-dapm.c
From: Fabio Estevam <festevam@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:01 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix printk format warning for 'formats':
>
> sound/soc/soc-dapm.c:2913:5: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'u64'

I have sent a fix for this earlier today and Mark has already applied it.
