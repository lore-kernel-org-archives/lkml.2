Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab2HJSVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:21:54 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:26299 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759751Ab2HJSVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:21:53 -0400
Date: Fri, 10 Aug 2012 20:21:51 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>,
        Vishwas A Deshpande <vishwas.a.deshpande@ti.com>,
        M R Swami Reddy <mr.swami.reddy@ti.com>, trivial@kernel.org
Subject: Re: [PATCH][trivial] ASoC: isabelle: Remove unneeded include of
 version.h
In-Reply-To: <20120810181631.GN24328@opensource.wolfsonmicro.com>
Message-ID: <alpine.LNX.2.00.1208102019510.17673@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1208102010480.17673@swampdragon.chaosbits.net> <20120810181631.GN24328@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Mark Brown wrote:

> On Fri, Aug 10, 2012 at 08:12:57PM +0200, Jesper Juhl wrote:
> > There is no need to include version.h in sound/soc/codecs/isabelle.c -
> > this patch removes the pointless include.
> 
> Not sure what this patch is against, there appears to be no include of
> version.h in current code...

It's against Linus's tree. I created a branch off of master at 
f4ba394c1b02e7fc2179fda8d3941a5b3b65efb6 and did the patch.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

