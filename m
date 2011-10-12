Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab1JLC5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 22:57:48 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:57535 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab1JLC5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 22:57:47 -0400
Subject: Re: [PATCH] rtc: rtc-puv3: Add __devinit and __devexit markers for
 probe and remove
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
In-Reply-To: <1318328732.1938.14.camel@epip-laptop>
References: <1317824987.2674.1.camel@phoenix>
	 <1318328732.1938.14.camel@epip-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Wed, 12 Oct 2011 10:58:51 +0800
Message-ID: <1318388331.1938.24.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I should acknowledge it, not sign off.

Acked-by: Guan Xuetao<gxt@mprc.pku.edu.cn>

I will push the patch into my repo, thanks.

Guan Xuetao

On Tue, 2011-10-11 at 18:25 +0800, Guan Xuetao wrote:
> Thanks Axel.
> 
> Signed-off-by: Guan Xuetao<gxt@mprc.pku.edu.cn>
> 
> Guan Xuetao
> 
> On Wed, 2011-10-05 at 22:29 +0800, Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/rtc/rtc-puv3.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
> > index b3eba3c..e4b6880 100644
> > --- a/drivers/rtc/rtc-puv3.c
> > +++ b/drivers/rtc/rtc-puv3.c
> > @@ -220,7 +220,7 @@ static void puv3_rtc_enable(struct platform_device *pdev, int en)
> >  	}
> >  }
> >  
> > -static int puv3_rtc_remove(struct platform_device *dev)
> > +static int __devexit puv3_rtc_remove(struct platform_device *dev)
> >  {
> >  	struct rtc_device *rtc = platform_get_drvdata(dev);
> >  
> > @@ -236,7 +236,7 @@ static int puv3_rtc_remove(struct platform_device *dev)
> >  	return 0;
> >  }
> >  
> > -static int puv3_rtc_probe(struct platform_device *pdev)
> > +static int __devinit puv3_rtc_probe(struct platform_device *pdev)
> >  {
> >  	struct rtc_device *rtc;
> >  	struct resource *res;
> 


