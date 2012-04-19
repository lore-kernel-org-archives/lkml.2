Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab2DSWZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:25:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab2DSWZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:25:09 -0400
Date: Fri, 20 Apr 2012 00:24:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Chris Ball <cjb@laptop.org>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: linux-next: triage for April 18, 2012
In-Reply-To: <878vhrjs6x.fsf@laptop.org>
Message-ID: <Pine.LNX.4.64.1204200023500.2110@axis700.grange>
References: <20120419020136.GB3443@windriver.com> <878vhrjs6x.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:yaDS4DASHLZdmMlCKVZuFoZvbakpcewwjVptEAvarBk
 rfbmLJcnHzG4ek3f9GQy3bQvINOOBYxJhgEeZqqatzLB/ANZHt
 Ga0oEuzKWa3sksa9Rnq+Y0lTKyNZNlonKZGfJFkWY0J9LMH50m
 5UR8NoIqZPWH0zm0gRmpCWQNRonOpGd8HOeSo0H0q/Inc/clxE
 moVWLpYKTVz1PETMDwyEf9EE/AsqEU6A/m3RXAd1fBH6S5K46L
 cVpNUqwvpwKkP3+mpOOwcv4bVYP0HxaIRHKvYkiWBpvbpbttiZ
 NjsYsjV1yhRvoOENfbspF6xSgcOCjeFZm6cXEYO3Z8DiFOKRxP
 FJoqEmg1YdiVvkKJjx7OCk5e4/qs2/tEGJ2Sa7uq138G39/X6n
 EF/1LrY5Vv7dQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Chris Ball wrote:

> Hi,
> 
> On Wed, Apr 18 2012, Paul Gortmaker wrote:
> > ARM:mackerel_defconfig,ag5evm_defconfig
> > 	when:	Apr 19 (possibly earlier?)
> > 	why:	pfc-sh7372.c: undefined reference to `mmc_detect_change'
> > 	why:	pfc-sh73a0.c: undefined reference to `mmc_detect_change'
> > 	status:	
> > 	fix:	
> > 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131930/
> > 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131908/
> 
> Adding Guennadi and Magnus to CC for this error (which is coming from
> tmio_mmc_cd_wakeup).

...waiting for these patches to make it in:

http://article.gmane.org/gmane.linux.ports.sh.devel/14412
http://article.gmane.org/gmane.linux.ports.sh.devel/14413

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
