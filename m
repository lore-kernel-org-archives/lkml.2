Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2GENyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:54:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab2GENyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:54:35 -0400
Date: Thu, 5 Jul 2012 15:54:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7 v2] ASoC: siu: don't use DMA device for channel
 filtering
In-Reply-To: <20120705120826.GU4111@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1207051549010.30191@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
 <1341484183-10757-3-git-send-email-g.liakhovetski@gmx.de>
 <20120705120826.GU4111@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:RAzSUJGjvQ8NkVag8AyKagy0GUkymRkzh4514lqlGPf
 DIe2cjFnk9uu/eEsgkB5t4SFqa35cqnDAMh53Jrs7elN78SYZL
 wF3IuXd3ms6afucljb1cTa06yXx1xDuz6g/992I3nTSu7wjy2F
 xIczn3EQzjRHhLbSZxJYpmWHfacRBVl1fmeIRp2reSXNsMGHPk
 lrwsQwM14ot/0745J98Vb5GrQNzXHPt7Y6wRuRmUDfcFGsbmge
 HuCGcDD+QWLgM1Y2Mlgaq+FWZnb1quL+n1jXiqNdo52bIFG9vr
 3flknyaem6RvKa6FZelGMcRA8+EfqixYcPRV3Thlhid1HLYdNi
 o59ux3HH8S49tZVBSIub1ow8RxlsNqNcQEbUnXiizq1N/oRtld
 RuerJwHvN6ZAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2012, Mark Brown wrote:

> On Thu, Jul 05, 2012 at 12:29:38PM +0200, Guennadi Liakhovetski wrote:
> > DMA channels are filtered based on slave IDs, no need to additionally filter
> > on DMA device.
> 
> This doesn't apply, please regenerate against current code.

Sure, as I mentioned in my description mail: "This patch series goes on 
top of my earlier patches to split shdma.c." And that patch series, also 
available at

git://github.com/lyakh/linux.git shdma-base

contains this patch:

commit 553d9459a90e9cc6997da2c34bb637794d6a4ac5
    ASoC: siu: prepare for conversion to the shdma base library

Sorry, I should have mentioned, that various DMA slave drivers also have 
dependencies in that series.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
