Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1G1UJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:09:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49626 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab1G1UJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:09:48 -0400
Date: Thu, 28 Jul 2011 22:09:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 1/2] MMC / TMIO: Fix build issue related to struct
 scatterlist
In-Reply-To: <201107272356.16817.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1107282205110.20737@axis700.grange>
References: <201107262049.15333.rjw@sisk.pl> <201107262050.23379.rjw@sisk.pl>
 <Pine.LNX.4.64.1107272236510.7435@axis700.grange> <201107272356.16817.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:DoqEfD51A8e1ITvVguAgL63ImDu885nEB3ENHoDZ46b
 cni+afITnB5DCwAVN+EIjfLpStyva89mQgKIRw56OXepo2gOUO
 M1mlFdtDsU7eCCoAs5tbiRcNSfvtTCR8SaS0LAY16/28axXYHQ
 6iXZNo3G4G2Cu3/rwRfIEIW2Yd8xnjbtYcjgkuSs2GHFHwH6zW
 nlHQQPOxh4RIVFytQsY3QOLVMI/xFwL4Ban5KaoCqE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Rafael J. Wysocki wrote:

> On Wednesday, July 27, 2011, Guennadi Liakhovetski wrote:
> > (added MMC maintainer to CC:)
> > 
> > On Tue, 26 Jul 2011, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Fix build issue caused by undefined struct scatterlist in
> > > drivers/mmc/host/tmio_mmc.c.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > A nitpick, if I may: sCatterlist comes before sPinlock in my versions of 
> > most popular alphabets;-) Please, fix (or maybe Chris can fix it himself), 
> 
> I'm not sure what you mean exactly (perhaps it's too late).

I mean, that the headers are atm sorted alphabetically and should remain 
so, therefore you should add the new header one line higher. As for 
compile failure or not: I haven't seen any compile failures myself, but 
the patch is academically correct, because structs, declared in tmio_mmc.h 
embed struct scatterlist, therefore the header has to be included in that 
header too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
