Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1DFJbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:31:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab1DFJbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:31:00 -0400
Date: Wed, 6 Apr 2011 12:29:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com, mingo@elte.hu
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110406092946.GD25626@redhat.com>
References: <1301592656.586.15.camel@jaguar>
 <4D982E89.8070502@redhat.com>
 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <m3liznkb5q.fsf@blackfin.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3liznkb5q.fsf@blackfin.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 10:59:45AM +0200, Markus Armbruster wrote:
> Anthony Liguori <anthony@codemonkey.ws> writes:
> 
> > On 04/03/2011 05:11 AM, Avi Kivity wrote:
> >> On 04/03/2011 12:59 PM, Pekka Enberg wrote:
> >>> Hi Avi,
> >>>
> >>> On Sun, Apr 3, 2011 at 11:23 AM, Avi Kivity<avi@redhat.com>  wrote:
> >>> >>  Note that this is a development prototype for the time being:
> >>> there's no
> >>> >>  networking support and no graphics support, amongst other missing
> >>> >>  essentials.
> >>> >
> >>> >  Mind posting a roadmap?  I would put smp support near the top.
> >>> This sort of
> >>> >  thing has to be designed in, otherwise you wind up with a big
> >>> lock like
> >>> >  qemu.
> >>>
> >>> What are the pain points with qemu at the moment?
> >>
> >> It's an ugly gooball.
> >
> > Because it solves a lot of very difficult problems.
> 
> And the solutions emerged / evolved over a long time.  Meanwhile, goals
> shifted.  It wasn't designed as user space for KVM, it got shoehorned
> into that role (successfully).
> 
> It has some solutions it should have left to other tools.  For instance,
> it shouldn't be in the network configuration business.
> 
> > You could drop all of the TCG support and it'd still be an ugly gooball.
> >
> > Supporting lots of different emulated hardware devices, live
> > migration, tons of different types of networking and image formats,
> > etc., all adds up over time.
> 
> It does.  Still, a fresh start could lead to a less ugly gooball.
> 
> >>> SMP, networking, and simpler guest to host communication from shell
> >>> are most interesting missing features for me.
> >>
> >> If it is to be more than a toy, then Windows (really generic guest)
> >> support, manageability, live migration, hotplug, etc. are all
> >> crucial.
> >
> > I concur that SMP is probably one of those features you need to start
> > with if you're designing something from scratch.
> 
> Certainly.  Another one that doesn't like retrofitting is security.
And migration :)

--
			Gleb.
