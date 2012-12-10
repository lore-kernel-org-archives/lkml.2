Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2LJHJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:09:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56684 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab2LJHJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:09:36 -0500
Date: Mon, 10 Dec 2012 16:09:28 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Liam Girdwood <lrg@ti.com>, matthias@kaehlcke.net,
        kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sound/soc/soc-core.c: drop kfree of devm_kzalloc's
 data
Message-ID: <20121210070927.GK10927@opensource.wolfsonmicro.com>
References: <1354989680-25794-1-git-send-email-Julia.Lawall@lip6.fr>
 <20121210052334.GI10927@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1212100709450.2213@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1212100709450.2213@localhost6.localdomain6>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 07:10:16AM +0100, Julia Lawall wrote:

> Sorry, I just resent the patch as is.  1 and 2 were I guess applied,
> because I odn't findthe problem any more.

It looks like this is what happened the first time round as well - I
only got patch 3 but it was flagged as part of a three patch series.
Please don't do things like this, it makes the patch look like part of a
series which has already been applied but didn't get deleted when it's
sitting in an inbox.
