Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869Ab2HJSYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:24:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45539 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759787Ab2HJSYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:24:07 -0400
Date: Fri, 10 Aug 2012 19:24:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>,
        Vishwas A Deshpande <vishwas.a.deshpande@ti.com>,
        M R Swami Reddy <mr.swami.reddy@ti.com>, trivial@kernel.org
Subject: Re: [PATCH][trivial] ASoC: isabelle: Remove unneeded include of
 version.h
Message-ID: <20120810182405.GO24328@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1208102010480.17673@swampdragon.chaosbits.net>
 <20120810181631.GN24328@opensource.wolfsonmicro.com>
 <alpine.LNX.2.00.1208102019510.17673@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1208102019510.17673@swampdragon.chaosbits.net>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 08:21:51PM +0200, Jesper Juhl wrote:
> On Fri, 10 Aug 2012, Mark Brown wrote:

> > Not sure what this patch is against, there appears to be no include of
> > version.h in current code...

> It's against Linus's tree. I created a branch off of master at 
> f4ba394c1b02e7fc2179fda8d3941a5b3b65efb6 and did the patch.

Ah, the fix is only in -next.
