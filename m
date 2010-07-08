Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0GHLEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:04:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0GHLD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:03:59 -0400
Date: Thu, 8 Jul 2010 14:03:34 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Palfrader <peter@palfrader.org>, Glauber Costa <glommer@redhat.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zachary Amsden <zamsden@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
 point for pvclock
Message-ID: <20100708110334.GT4689@redhat.com>
References: <20100701175144.GA2116@kroah.com>
 <20100701173218.125822294@clark.site>
 <20100707124731.GJ15122@anguilla.noreply.org>
 <20100707135140.GI2707@mothafucka.localdomain>
 <20100707143338.GK15122@anguilla.noreply.org>
 <20100707151540.GH4689@redhat.com>
 <20100707200536.GL15122@anguilla.noreply.org>
 <20100708053100.GJ4689@redhat.com>
 <20100708085114.GM15122@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708085114.GM15122@anguilla.noreply.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 10:51:14AM +0200, Peter Palfrader wrote:
> On Thu, 08 Jul 2010, Gleb Natapov wrote:
> 
> > > > And what if you provide -cpu qemu64,-kvmclock to qemu command line?
> > > 
> > > Adding that to the glob of options that already were there from libvirt
> > > didn't disable it, but using an LD_PRELOAD wrapper[1] to that purpose on
> > > the host when starting kvm did help.
> > > 
> > Strange. -kvmclock should have had the same effect. What qemu is it?
> > What is your command line?
> 
> | QEMU PC emulator version 0.11.1 (qemu-kvm-0.11.1), Copyright (c) 2003-2008 Fabrice Bellard
> from the debian package qemu-kvm (0.11.1+dfsg-1~bpo50+1)
That explain it. 0.11 is really old. Don't have this ability.

> [should we trim the CC list?  If yes, to what?]
Better not to.

--
			Gleb.
