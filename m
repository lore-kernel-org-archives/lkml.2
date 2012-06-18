Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2FRJwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:52:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50340 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2FRJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:52:21 -0400
Date: Mon, 18 Jun 2012 11:52:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: extend the fixed voltage regulator to accept
 voltage
In-Reply-To: <20120618094145.GC3974@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:9x1+74NpL+OdFtFVBgpHQMPT7OPCJUsVUry2q9wd7a4
 LyeocRgwEl0SNnC6YQCn06vkIX5GSUpkrVFxUUCvZUkwblFpNk
 pBugJo0FbBhw55Ty59sxMGB6W37n7PlXx0FZDSKVlwF5wEtBOi
 rL15tMJSCx0Tsx0YIjGcpBRW2nEgjdkO0ViyDW1j5EUUtFtZts
 GwLamnkRU1DJprtfiAzjSQJxOhJpyPoLG0Mj30ko1agpxiltBD
 SMK2owZ5C7k5KGrp/16uMTFlhvvpTb6Wy5sv3BrtF7aQ5FtyX/
 pX+XLt8LTBK5a8EQBk6KGYYQPgxH0jwccZ9y0dJUrZk3rU7mqZ
 1I9k4Hc2LPN3PL7f0QZfhhRQhLfMAqzHQXwF0BjxX+xZ6lhLFE
 8tE+UUFBHrG0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Mark Brown wrote:

> On Mon, Jun 18, 2012 at 10:19:42AM +0200, Guennadi Liakhovetski wrote:
> 
> > +#define FIXED_BASE "fixed-dummy"
> > +#define FIXED_NAME FIXED_BASE "-00"
> > +
> >  struct fixed_regulator_data {
> >  	struct fixed_voltage_config cfg;
> >  	struct regulator_init_data init_data;
> >  	struct platform_device pdev;
> > +	char name[sizeof(FIXED_NAME)];
> 
> So, this looks pretty ugly and doesn't seem terribly directly related to
> supplying a voltage parameter.  Please split it out into a separate
> change.

Well, I never insist on being the most advanced aesthetics connaisseur, 
but I think these two changes are related. The point is, that if we want 
to support different voltages, boards will have several of these 
regulators, therefore they'll need different names. We could splt this, 
but just the first part - changing the name - would look kinda pointless 
without the second one, don't you think?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
