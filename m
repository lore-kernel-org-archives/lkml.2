Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340Ab2DKVwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:52:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17797 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761200Ab2DKVwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:52:22 -0400
Date: Wed, 11 Apr 2012 23:52:21 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: almost time to run my kernel source cleaning scripts again?
In-Reply-To: <alpine.DEB.2.02.1204111700170.4733@oneiric>
Message-ID: <alpine.LNX.2.00.1204112350590.2137@swampdragon.chaosbits.net>
References: <alpine.DEB.2.02.1204111700170.4733@oneiric>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, Robert P. J. Day wrote:

> 
>   it's been a while so i was thinking of firing up my scripts to
> peruse the source tree looking for oddities/inconsistencies/whatever
> (unless someone else is already doing that).
> 
>   one example is looking for preprocessor tests of symbols that aren't
> defined in any Kconfig file, and i can focus on any part of the source
> tree.  for example, if i run that script against drivers/mmc, i get:
> 
> >>>>> MMC_MSM7X00A_RESUME_IN_WQ
> drivers/mmc/host/msm_sdcc.c:1408:#ifdef CONFIG_MMC_MSM7X00A_RESUME_IN_WQ
> 
> telling me that a source file is testing a CONFIG variable that
> doesn't exist.
> 
>   the scripts are available online 

I'd be interrested in taking a look at those. Got a URL where I can grab 
them?


[...]

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

