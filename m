Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2A2Vmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 16:42:53 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21216 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab2A2Vmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 16:42:52 -0500
Date: Sun, 29 Jan 2012 22:43:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Sound, SoC, WM9090: Remove unused variable 'wm9090' from
 wm9090_i2c_remove()
In-Reply-To: <20120129214205.GD2994@opensource.wolfsonmicro.com>
Message-ID: <alpine.LNX.2.00.1201292242530.27749@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201280055410.13952@swampdragon.chaosbits.net> <20120129214205.GD2994@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jan 2012, Mark Brown wrote:

> On Sat, Jan 28, 2012 at 12:57:42AM +0100, Jesper Juhl wrote:
> > The variable 'wm9090' is assigned to but never used, so let's just
> > remove it.
> 
> There's already a fix in for this (adding use back).
> 
Ok. Thank you for letting me know.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

