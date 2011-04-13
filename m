Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab1DMKbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:31:51 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:49911 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187Ab1DMKbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:31:50 -0400
Date: Wed, 13 Apr 2011 12:31:44 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Andreas Schwab <schwab@redhat.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>
Subject: Re: small git lesson [Was: Re: Revert
	737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?]
Message-ID: <20110413103144.GB3066@iram.es>
References: <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com> <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local> <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local> <20110412113033.GA16649@iram.es> <1302608770.27054.36.camel@thor.local> <20110413080204.GA3871@iram.es> <20110413081246.GK18850__3180.67204575545$1302682420$gmane$org@pengutronix.de> <m339lm8r31.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m339lm8r31.fsf@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:59:14AM +0200, Andreas Schwab wrote:
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:
> 
> > $ git name-rev --refs=refs/tags/v2.6\* 69a07f0b117a40fcc1a479358d8e1f41793617f2
> > 69a07f0b117a40fcc1a479358d8e1f41793617f2 tags/v2.6.39-rc2~3^2~43^2~4
> >
> > so it was introduced just before -rc2.
> 
> $ git tag --contains 69a07f0b117a40fcc1a479358d8e1f41793617f2
> v2.6.39-rc1
> v2.6.39-rc2
> 

So who is right? I think it was before rc1. 

Anyway I'm aware that there are other git commands, although for the option
details I often have to have a look at the man page.

However in this case the main reason to fire gitk was to have a quick look 
at the patch and its context, and simply reported the "Precedes" line 
in the display, which is 2.6.39-rc1. It also follow v2.6.37-rc2, which means
that it has been quite a long time outside the main tree.

	Gabriel
