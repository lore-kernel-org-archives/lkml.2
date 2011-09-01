Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1IAWMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:12:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58085 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1IAWMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:12:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 0/5] PM: Generic PM domains and device PM QoS
Date: Fri, 2 Sep 2011 00:14:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>
References: <201108310017.03103.rjw@sisk.pl> <CAORVsuVJEbLRXLuQFUh3_rDf+DfNFpOhEuBr33SRKqxBos=6Bw@mail.gmail.com>
In-Reply-To: <CAORVsuVJEbLRXLuQFUh3_rDf+DfNFpOhEuBr33SRKqxBos=6Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109020014.39027.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, September 01, 2011, Jean Pihet wrote:
> Rafael,
> 
> On Wed, Aug 31, 2011 at 12:17 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > This patchset illustrates how device PM QoS may be used along with
> > PM domains in my view.
> >
> > Actually, it consists of two parts.  Namely, patches [1-3/5] seem to be
> > suitable for 3.2, unless somebody hates them,
> The patches [1-3/5] are ok (reviewed only) excepted some remarks I have.

OK, thanks for the comments.

> > but patches [4-5/5] are
> > total RFC.  They haven't been tested, only compiled, so the use of them
> > is not encouraged (they may kill your dog or make your cat go wild, or
> > do something equally nasty, so beware).
> That looks like a disclaimer ;p
> 
> > Their purpose is to illustrate
> > an idea that I'd like to discuss at the PM miniconference during the
> > LPC.
> There is some code for OMAP that dynamically updates the worst case
> values for devices activation and de-activation;
> cf._omap_device_activate and _omap_device_deactivate in
> arch/arm/plat-omap/omap_device.c. The idea is to start with reference
> figures (worst case measured on board) at boot and then update the
> worst case values at runtime.
> Based on the PM QoS values and the worst case latency values the next
> power domains states can be determined. Unfortunately this is not
> (yet) implemented.

I thought about that too, but I'd like to discuss the basic idea first.

> I am wondering if the patches [4-5/5] are meant to replace the OMAP
> code, which would be really nice.

I certainly hope they will be useful for multiple platforms.  Whether
or not OMAP turns out to be one of them I can't tell at the moment.

Thanks,
Rafael
