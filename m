Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab1DMXV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:21:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:48957 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933347Ab1DMXV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:21:28 -0400
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: kevin diggs <diggskevin38@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	 <1302646173.28876.53.camel@pasglop> <1302652502.28876.76.camel@pasglop>
	 <19877.23529.745123.819112@pilspetsen.it.uu.se>
	 <1302685102.28876.81.camel@pasglop>
	 <BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 09:21:09 +1000
Message-ID: <1302736869.28876.91.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 12:52 -0500, kevin diggs wrote:
> > Actually I do get a crash in X later on... something in the radeon
> DRM
> > interrupt code is getting what looks like a NULL dereference. I'll
> try
> > to dig that one later on. I don't know if it's related to your
> problem
> > at all though.
> >
> In this context, what does 'crash' mean? The X thingy goes down? Or
> the whole OS? 

Depends, with xmon enabled you get into xmon :-) Dunno if the oops is
fatal but it could be.

Cheers,
Ben.

