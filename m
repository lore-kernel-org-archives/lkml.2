Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2KTKDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:03:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTKDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:03:07 -0500
Date: Tue, 20 Nov 2012 11:02:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: DVS regulator drivers
In-Reply-To: <20121120010547.GD4483@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1211201054260.21420@axis700.grange>
References: <Pine.LNX.4.64.1211191213380.11024@axis700.grange>
 <20121120010547.GD4483@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:YgRvDOwAZmvSFt7NgS+oo2a4BsHd7+UUe/IOF4KMLDp
 aOiwRXnsHj29widFzx/voOilhUOoNjKRhhZ49WdOmm1lLaeWo0
 goXA4VBrhD6+Gt2VvoEO9G5hmO9/dfOk4pp9aLMu8/HesgMEuW
 djlhA6Qnhqtw5ET/mR8B7wMDYeka1qTzvba7fEJy71KFtbLF/X
 TIqxOUnF5sA1eZG8OXncLcWoLM4OPfn50CATKtTed+P55N+D/j
 yvvWqEm8uybkcvRU6GY3nm6awG8LRmWmvmJSWD6FQKk3iMhvTh
 VcKX/5SMPXMG1/jhXfz83nWjvZWs8YVxvcPfvZTAU4hrac+M63
 xR+AJfXh3JCzY+O1872UpvxvLJb1udfZa5bThLL3bmkqJjUvF7
 U9w7igJpCrY5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, one more point, that I raised in the original mail yesterday and 
that I forgot about, when replying today:

On Tue, 20 Nov 2012, Mark Brown wrote:

> On Mon, Nov 19, 2012 at 12:52:09PM +0100, Guennadi Liakhovetski wrote:

[snip]

> > 	/* Always set the ON status to the minimum voltage */
> > 
> > but I actually don't see, where the minimum is selected. It seems instead 
> > in this case the "ON" value is just set:

In other words, I don't see where voltages are compared to select the 
minimum to be used for .on_vsel. Instead, it seems, .on_vsel is always set 
to the new value, and, if it is also higher then the old .dvs_vsel value, 
.dvs_vsel is _also_ set to the new voltage, in which case they become 
equal. Is this the intended behaviour?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
