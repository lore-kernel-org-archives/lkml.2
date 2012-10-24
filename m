Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934803Ab2JXNgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:36:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2JXNgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:36:43 -0400
Date: Wed, 24 Oct 2012 15:36:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Ming Lei <tom.leiming@gmail.com>
cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-sh@vger.kernel.org
Subject: Re: [Q] "console=" command line ignored?
In-Reply-To: <CACVXFVOv-zMj_cEyRuehhWMjCF1nvd-tkW7c8o5raHZoMbCZiQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1210241535560.2683@axis700.grange>
References: <Pine.LNX.4.64.1210241226060.31768@axis700.grange>
 <CACVXFVOv-zMj_cEyRuehhWMjCF1nvd-tkW7c8o5raHZoMbCZiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:jK8Xx6OuiTAGAWxxzSqkM66MiEWoJ5NBXyB+0v0Vh8D
 gwPjvCbXkVJu1gWgF7MGNIp0wQNdleSrPkIBuCrn+HN1/SmPnz
 Iczwux64AE/FKmHul55mjR2OE968wYebnH+4KwVCHBkEa5PvSi
 QzHtwsNBpf4vA5lsFCUFL9YbYUdLiGnevgGtEHGIwFMP9KkGJx
 KaJa/NRVh6zj3bxCUXJZ0j1qXmb7oGMMk3+Ti6tv92icXEhqzB
 s70qUqRkf1+t5sOa6KU60vCRnokX3eZG0fjfMVdmWvuYjcwcEI
 1iyX9Kq/myVxY74/3SB/S8wqPGgd+pbbFAJ12BYxHOOY3DE/kG
 YcbwsbD/3Sq6xzmbt2hyYXQtmHrpPj/b6Dz1VT1CqL1MU1ptFf
 FL1fGbg9Xyffw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Ming Lei wrote:

> On Wed, Oct 24, 2012 at 6:49 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi
> >
> > I cannot seem to force selection of a serial console by specifying
> > "console=ttySC0..." on the command line with modern (yesterday's "next")
> > kernels. The kernel insists on
> >
> > console [tty0] enabled
> 
> Please see https://lkml.org/lkml/2012/10/23/307

Perfect, thanks! Fixes my problem too.

Regards
Guennadi

> > The reason might also well be, that the respective "sh-sci" driver is
> > only registered later. I'll try to look at this in more detail - since
> > when this is broken and how the registration order looked before. This is
> > just a first heads-up in case someone has a solution immediately at hand.
> 
> 
> 
> Thanks,
> -- 
> Ming Lei
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
